#!/bin/bash
# Update and install nginx
sudo apt-get update -y
sudo apt-get install -y nginx awscli
# Enable nginx to start on boot
sudo systemctl enable nginx

# Download the index.html from your private S3 bucket
aws s3 cp s3://secureapp-assets/index.html /var/www/html/index.html

# Restart nginx to load new page
systemctl restart nginx
