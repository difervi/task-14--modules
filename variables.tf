variable "aws_region" {
  description = "AWS region where all resources are deployed."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to build the names of all resources."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnets keyed by name suffix (e.g. a, b, c), each with a CIDR block and availability zone."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "allowed_ip_range" {
  description = "List of CIDR ranges allowed to access the instances over SSH and the load balancer over HTTP."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template."
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
