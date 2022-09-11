variable "region" {
description = "The AWS region."
}
variable "prefix" {
description = "The name of our org, e.g., examplecom."
  default = "vodafone.com"
}
variable "environment" {
description = "The name of our environment, e.g., development."
default = "development"
}
variable "key_name" {
description = "The AWS key pair to use for resources."
}
variable "vpc_cidr" {
description = "The CIDR of the VPC."
  default = "10.0.0.0/16"
}
variable "public_subnets" {
default = ["10.0.1.0/24","10.0.2.0/24"]
description = "The list of public subnets to populate."
}
variable "private_subnets" {
default = ["10.0.3.0/24","10.0.4.0/24"]
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
