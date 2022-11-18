output "VPC-ID-MASTER" {
  value = aws_vpc.lab_vpc_master.id
}

output "teleport_server" {
  value = aws_instance.teleport_instance.public_dns
}

output "teleport_clients" {
  value = {
    for instance in aws_instance.lab_instances :
    instance.public_dns => instance.private_ip
  }
}

### The Ansible inventory 
resource "local_file" "ansible_hosts_inventory" {
  content = templatefile("hosts.tmpl", {
    teleport_server_public_dns  = aws_instance.teleport_instance.public_dns,
    teleport_clients_public_dns = aws_instance.lab_instances.*.public_dns
    }
  )
  filename = "hosts_${local.current_date}"
}