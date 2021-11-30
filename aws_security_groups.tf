# SG configuration (Master)
resource "aws_security_group" "lab-master-sg" {
  provider    = aws.region-master
  name        = "lab-master-sg"
  description = "Allow TCP/8080 & TCP/22 & TCP/80"
  vpc_id      = aws_vpc.lab_vpc_master.id

  ingress {
    description = "Allow TCP/22 for our public IP"
    cidr_blocks = [var.external_ip]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

  }

  ingress {
    description = "Allow TCP/22 for our public IP"
    cidr_blocks = [var.external_ip]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

  }

  ingress {
    description = "Allow anyone on port 8080"
    from_port   = var.webserver_port
    to_port     = var.webserver_port
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }

  egress {
    description = "Allow any outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # This is for all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "lab-master-sg"
  }
}
