variable "vpc_name" {
  description = "Name tag of the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnets to create, keyed by an identifier, each with a name, CIDR block and availability zone."
  type = map(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "igw_name" {
  description = "Name tag of the internet gateway."
  type        = string
}

variable "route_table_name" {
  description = "Name tag of the public route table."
  type        = string
}
