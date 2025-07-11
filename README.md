# SecureApp Infrastructure with Terraform on AWS

This project uses **Terraform** to deploy a scalable, secure, and modular infrastructure on **Amazon Web Services (AWS)**. The infrastructure powers a web application served via **Nginx on EC2**, with static content downloaded from **S3**, and is fronted by an **Application Load Balancer (ALB)**.

> ✅ SSH access to private EC2 instances is intentionally omitted. All validation is done via the ALB DNS output.

---

## Project Features

- ✅ Custom **VPC** with public and private subnets
- ✅ **Internet Gateway** and **NAT Gateway** setup
- ✅ **Public S3 bucket blocked** (private access only)
- ✅ **IAM Roles and Instance Profiles** for EC2 → S3 access
- ✅ EC2 instances via **Auto Scaling Group (ASG)** and **Launch Template**
- ✅ **User Data script** that installs Nginx and fetches HTML from S3
- ✅ **Application Load Balancer (ALB)** that forwards traffic to EC2s
- ✅ Separate **security groups** for ALB and web tier
- ✅ Modular design using **Terraform modules**
- ✅ Output includes **ALB DNS name** to test the web application

---

## Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform ≥ 1.4.0
- IAM user with permissions to create AWS resources

---

✅ Project Structure
```bash
secureapp-terraform/
│
├── modules/
│   ├── vpc/               # VPC, subnets, NAT, routing
│   ├── sg/                # Security groups (ALB, Web)
│   ├── alb/               # ALB, Target Group, Listener
│   ├── ec2/               # Launch Template, ASG
│   ├── s3/                # S3 bucket config + index.html
│   │   └── index.html     # Static page served via EC2+Nginx
│   └── iam/               # IAM Role & Instance Profile for EC2
│
├── userdata.sh            # Bootstraps EC2 to install Nginx and fetch S3 page
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## Project Overview 

The goal of this project is to deploy a scalable and secure web application infrastructure on AWS using Terraform — entirely from scratch and fully automated.

**What Are We Trying to Achieve?**

**We want to:**

✅ Host a static web page stored in an S3 bucket

✅ Use EC2 instances (inside a private network) to serve that web page using Nginx

✅ Automatically download the page from S3 during EC2 boot via user data script

✅ Distribute web traffic using an Application Load Balancer (ALB)

✅ Build this using Terraform modules to make it clean, reusable, and scalable

✅ Keep the application secure by:

Hiding EC2 inside private subnets

Blocking public access to the S3 bucket

Using IAM roles to allow EC2 to access S3 securely

Exposing only the ALB to the public internet

---

## How Everything is Connected (Architecture)

**1. VPC Module**

Creates the networking layer:

A custom VPC

Two public subnets (for ALB, NAT Gateway)

Two private subnets (for EC2 instances)

Internet Gateway to allow access to public internet

NAT Gateway so private instances can reach the internet for software updates

**2. Security Groups (SG) Module**

Creates firewall rules:

ALB SG → allows inbound HTTP (port 80) from the internet

Web SG → allows only ALB to access EC2 on port 80

**3. ALB Module**

Sets up:

Application Load Balancer in public subnets

Target Group to register EC2 instances

Listener to forward traffic on port 80 to the Target Group

Purpose: ALB is the only public entry point to the app. It distributes HTTP requests to the EC2 web servers in private subnets.

**4. S3 Module**

Creates:

A private S3 bucket named secureapp-assets

Server-side encryption

Public access is blocked

Contains index.html — your static web page

Purpose: The EC2 instances will download this file during startup and serve it via Nginx.

**5. IAM Module**

Creates:

An IAM Role for EC2 with a read-only S3 policy

An Instance Profile to attach the role to EC2

Purpose: This allows EC2 instances to securely access the private S3 bucket without needing access keys.

**6. EC2 Module**

Creates:

A Launch Template with:

Nginx + AWS CLI installation

S3 index.html copy via userdata.sh

An Auto Scaling Group to launch EC2 instances in private subnets

EC2 instances are attached to the ALB’s target group

Purpose: These EC2 instances host Nginx and serve the downloaded static page. They scale automatically based on ASG settings.

**User Flow (How the System Works)**

User enters the ALB DNS name in a browser.

The request goes to the ALB on port 80.

ALB forwards it to EC2 instances inside private subnets.

The EC2 instances run Nginx, which serves the static page downloaded from the S3 bucket.

The user sees your page:

**“Hello from a Private S3 Bucket!”**

---

## How to Deploy

### 1. Clone the Repo

```bash
git clone https://github.com/Sushmitha6300/terraform-web-stack.git
cd terraform-web-stack
```
### 2. Initialize Terraform
```bash
terraform init
```
### 3. Plan the Infrastructure
```bash
terraform plan
```

### 4. Apply the Infrastructure
```bash
terraform apply
```

Type yes when prompted.


### 5. Access the Web App

Once the infrastructure is deployed, Terraform will output the ALB DNS name.

Open it in your browser:
```bash
http://alb-dns-name
```

You should see:
```bash
Hello from a Private S3 Bucket!
This is a static web page served from S3 via Nginx on EC2.
```

**✅ The <title> of the page will say: Welcome to Sushmitha's Web App**

## How to Destroy

To clean up all resources:
```bash
terraform destroy
```

## Security Notes

No keys or secrets are included in this repo.

All AWS credentials are handled via your local ~/.aws/credentials.

SSH access to EC2 instances is not exposed in this project.

## Author

Sushmitha A

Passionate DevOps learner 