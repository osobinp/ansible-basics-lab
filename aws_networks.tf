# Create VPC in us-east-1
resource "aws_vpc" "lab_vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "lab_vpc_master"
  }

}

# Create IGW in us-east-1
resource "aws_internet_gateway" "lab_igw_master" {
  provider = aws.region-master
  vpc_id   = aws_vpc.lab_vpc_master.id
  tags = {
    "Name" = "lab_igw_master"
  }

}

# Get all available AZ's in VPC for master
data "aws_availability_zones" "az_master" {
  provider = aws.region-master
  state    = "available"

}

# Create subnet #1 in us-east-1
resource "aws_subnet" "subnet_master1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.az_master.names, 0)
  vpc_id            = aws_vpc.lab_vpc_master.id
  cidr_block        = "10.0.0.0/24"
  tags = {
    "Name" = "lab_subnet_master1"
  }
}

# Create routing table for us-east-1
resource "aws_route_table" "route_internet" {
  provider = aws.region-master
  vpc_id   = aws_vpc.lab_vpc_master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw_master.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    "Name" = "lab_master-routingtable"
  }

}

# # Overwrite default route table for VPC (Master) with our route table entries
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.lab_vpc_master.id
  route_table_id = aws_route_table.route_internet.id
}
