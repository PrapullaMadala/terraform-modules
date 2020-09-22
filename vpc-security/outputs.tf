output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "security_group" {
  value = aws_security_group.security_group.id
}