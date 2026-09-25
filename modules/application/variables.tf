variable "vpc_id" {
  description = "ID of the VPC where the target group is created."
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets used by the Auto Scaling group and the load balancer."
  type        = list(string)
}

variable "instance_security_group_ids" {
  description = "Security group IDs attached to the instances' network interface."
  type        = list(string)
}

variable "lb_security_group_ids" {
  description = "Security group IDs attached to the Application Load Balancer."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template."
  type        = string
}

variable "launch_template_name" {
  description = "Name of the launch template."
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling group."
  type        = string
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group."
  type        = number
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling group."
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling group."
  type        = number
}

variable "lb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
}

variable "target_group_name" {
  description = "Name of the load balancer target group."
  type        = string
}
