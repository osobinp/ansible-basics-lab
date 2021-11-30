variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "webserver_port" {
  type    = number
  default = 8080
}

variable "override_s3_key" {
  default = ""
}

locals {
  ec2_keypair = var.override_s3_key != "" ? var.override_s3_key : "keypair-${timestamp()}"
}