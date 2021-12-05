# Get Linux AMI ID using SSM Parameter endpoint
data "aws_ssm_parameter" "Linux_AMI_master" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Provide public key for EC2 instances
resource "aws_key_pair" "master_key" {
  provider   = aws.region-master
  key_name   = local.ec2_keypair
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create and bootstrap EC2 instance
resource "aws_instance" "lab_instances" {
  provider                    = aws.region-master
  count                       = var.instance_count
  ami                         = data.aws_ssm_parameter.Linux_AMI_master.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.master_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab-master-sg.id]
  subnet_id                   = aws_subnet.subnet_master1.id
  tags = {
    "Name" = join("_", ["ansible_workhorse", count.index + 1])
  }

  depends_on = [
    aws_main_route_table_association.set-master-default-rt-assoc, aws_route_table.route_internet
  ]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
sleep 60
ansible-playbook -e 'linux_hosts=tag_Name_${self.tags.Name}' ansible_aws_ec2/ec2_instance_configure.yml
ansible-playbook -e 'linux_hosts=tag_Name_${self.tags.Name}' ansible_aws_ec2/ec2_user_configure.yml
EOF
  }

}
