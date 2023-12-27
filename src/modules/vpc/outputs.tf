output "tmb_vpc_id" {
  description = "VPC Id"
  value       = aws_vpc.tmbVPC.id
}

output "tmb_public_subnets" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = [
    aws_subnet.tmbPublicSubnet1,
    aws_subnet.tmbPublicSubnet2
  ]
}

output "tmb_private_subnets" {
  description = "Will be used by RDS Module to set subnet_ids"
  value = [
    aws_subnet.tmbPrivateSubnet1,
    aws_subnet.tmbPrivateSubnet2
  ]
}
