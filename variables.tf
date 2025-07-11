variable "region" {
  type        = string
  description = "AWS region"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2 and Bastion"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}


