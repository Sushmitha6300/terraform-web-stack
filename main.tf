terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = var.region
}

# Fetch latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


module "vpc" {
  source  = "./modules/vpc"
  project = var.project
  vpc_cidr = var.vpc_cidr
  azs      = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "sg" {
  source  = "./modules/sg"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
}

module "iam" {
  source      = "./modules/iam"
  project     = var.project
  bucket_name = var.bucket_name
}

module "s3" {
  source      = "./modules/s3"
  project     = var.project
  bucket_name = var.bucket_name
}

module "ec2" {
  source                = "./modules/ec2"
  project               = var.project
  ami_id                = data.aws_ami.ubuntu.id
  instance_type         = var.instance_type
  userdata_path        = "${path.module}/userdata.sh"
  instance_profile_name = module.iam.instance_profile_name
  web_sg_id             = module.sg.web_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
}
