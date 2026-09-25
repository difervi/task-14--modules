output "vpc_id" {
  description = "ID of the VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.network.public_subnet_ids
}

output "ssh_sg_id" {
  description = "ID of the SSH security group."
  value       = module.network_security.ssh_sg_id
}

output "public_http_sg_id" {
  description = "ID of the public HTTP security group."
  value       = module.network_security.public_http_sg_id
}

output "private_http_sg_id" {
  description = "ID of the private HTTP security group."
  value       = module.network_security.private_http_sg_id
}

output "lb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.application.lb_dns_name
}
