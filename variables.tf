variable "region" {
description = "The AWS region."
}
variable "prefix" {
description = "The name of our org, e.g., examplecom."
}
variable "environment" {
description = "The name of our environment, e.g., development."
}
variable "key_name" {
description = "The AWS key pair to use for resources."
}
variable "vpc_cidr" {
description = "The CIDR of the VPC."
}
variable "public_subnets" {
default = []
description = "The list of public subnets to populate."
}
variable "private_subnets" {
default = []
description = "The list of private subnets to populate."
}

variable "ami" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0f9fc25dd2506cf6d"
    # "us-west-1" = "ami-7c4b331c"
    # "eu-west-1" = "ami-0ae77879"
  }

  description = "The AMIs to use for web and app instances."
}

variable "instance_type" {
  type = string
  default     = "t2.micro"
  description = "The instance type to launch "
}