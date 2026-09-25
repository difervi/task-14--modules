data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd

    TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

    echo "This message was generated on instance $${INSTANCE_ID} with the following IP: $${PRIVATE_IP}" > /var/www/html/index.html

    systemctl enable --now httpd
  EOF
}

resource "aws_launch_template" "this" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = base64encode(local.user_data)

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = var.instance_security_group_ids
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.launch_template_name
    }
  }

  tags = {
    Name = var.launch_template_name
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  desired_capacity    = var.asg_desired_capacity
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_security_group_ids
  subnets            = var.subnet_ids

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_target_group" "this" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
  }

  tags = {
    Name = var.target_group_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = aws_lb_target_group.this.arn
}
