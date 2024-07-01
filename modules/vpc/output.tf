output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subent" {
  value = aws_subnet.public_subent.*.id
}

output "private_subent" {
  value = aws_subnet.private_subent.*.id
}