output "VPC-ID-MASTER" {
  value = aws_vpc.lab_vpc_master.id
}

output "workshop_addresses" {
  value = {
    for instance in aws_instance.lab_instances:
    instance.public_dns => instance.private_ip
  }
}