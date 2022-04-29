variable "region" {
  type = string
  description = "The AWS region."
}

variable "environment" {
  type = string
  description = "The name of our environment, i.e. development."
  default = "development"
}

variable "key_name" {
  type = string
  description = "The AWS key pair to use for resources."
  default = "development"
}

variable "vpc_cidr" {
  type = string
  description = "The CIDR of the VPC."
}

variable "public_subnets" {
  type = list(string)
  default     = []
  description = "The list of public subnets to populate."
}

variable "private_subnets" {
  type = list(string)
  default     = []
  description = "The list of private subnets to populate."
}

variable "enable_dns_hostnames" {
  type = bool
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  type = bool
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = true
}


variable "availability_zones" {
  type = list(string)
   default = ["us-east-1a", "us-east-1b", "us-east-1c"]
} 

output "vpc_id" {
  value = aws_vpc.environment.id
}

output "vpc_cidr" {
  value = aws_vpc.environment.cidr_block
}


output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private[*].id
}

output "default_security_group_id" {
  value = aws_vpc.environment.default_security_group_id
}

