output "main-private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in module.vpc-main.private_subnet_arns : subnet]
}

output "main-vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc-main.vpc_id
}

output "main-private_network_acl_arns" {
  description = "The ARNs of the private network ACLs"
  value       = module.vpc-main.private_network_acl_arn
}

output "privatelink_service_name" {
  value = aws_vpc_endpoint_service.privatelink_service.service_name
}