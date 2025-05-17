output "vpc_id" {
  value       = aws_vpc.demo.id
  description = "Present VPC id info"
}

output "vpc_cidr" {
  value       = aws_vpc.demo.cidr_block
  description = "Present cidr blocks"
}

output "vpc_route_table_ids" {
  value       = [concat(aws_route_table.demo.*.id, aws_route_table.demo_private.*.id)]
  description = "Present route tables ids"
}

output "private_subnet_ids" {
  value       = [aws_subnet.demo_private.*.id]
  description = "Present private subnet ids"
}

output "public_subnet_ids" {
  value       = [aws_subnet.demo.*.id]
  description = "Present public subnet ids"
}
