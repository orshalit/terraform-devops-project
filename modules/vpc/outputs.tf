output "public_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for s in aws_subnet.private_subnet : s.id]
}
