resource "aws_s3_bucket" "web_assets" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.project}-web-assets"
  }

  force_destroy = true # Optional: allow auto-delete during destroy
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.web_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.web_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.web_assets.id
  key    = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"
}
