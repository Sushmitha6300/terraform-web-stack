variable "project" {
  type        = string
  description = "Project name for naming resources"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "userdata_path" {
  type        = string
  description = "Path to the user data script"
}

variable "instance_profile_name" {
  type        = string
  description = "IAM Instance Profile name"
}

variable "web_sg_id" {
  type        = string
  description = "Security group for web server"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ASG"
}

variable "target_group_arn" {
  type        = string
  description = "Target Group ARN for the ALB"
}
