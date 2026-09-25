aws_region  = "eu-west-1"
name_prefix = "cmtr-uad9vkoz"

vpc_cidr_block = "10.10.0.0/16"

public_subnets = {
  a = {
    cidr_block        = "10.10.1.0/24"
    availability_zone = "eu-west-1a"
  }
  b = {
    cidr_block        = "10.10.3.0/24"
    availability_zone = "eu-west-1b"
  }
  c = {
    cidr_block        = "10.10.5.0/24"
    availability_zone = "eu-west-1c"
  }
}

allowed_ip_range = ["18.153.146.156/32", "152.203.235.211/32"]

instance_type        = "t3.micro"
asg_desired_capacity = 2
asg_min_size         = 2
asg_max_size         = 2
