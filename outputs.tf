output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.alb.alb_dns_name
}

output "s3_bucket" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}
