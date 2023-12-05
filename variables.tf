variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the web server."
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group."
  type        = string
}

variable "security_group_description" {
  description = "The description of the security group."
  type        = string
}

variable "security_group_ingress_cidr_blocks" {
  description = "CIDR blocks for ingress rules."
  type        = list(string)
}

variable "security_group_egress_cidr_blocks" {
  description = "CIDR blocks for egress rules."
  type        = list(string)
}

