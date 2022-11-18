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
  default = "t3.medium" # or t2.small = 64
}

variable "instance_count" {
  type    = number
  default = 2 #46
}

variable "webserver_port" {
  type    = number
  default = 8080
}

variable "override_s3_key" {
  default = ""
}

locals {
  current_timestamp  = timestamp()
  current_date       = formatdate("YYYY-MM-DD-hh-mm-ss", local.current_timestamp)
  ec2_keypair = var.override_s3_key != "" ? var.override_s3_key : "keypair-${local.current_date}"
}
