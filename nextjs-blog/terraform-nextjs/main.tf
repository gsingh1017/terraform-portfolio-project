provider "aws" {
  region = "ca-central-1"
}


# S3 Bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "gs-nextjs-terraform-project-bucket" 
}


# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_control" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# S3 Block Public Access
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_block_public_access" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


# S3 Bucket ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_control,
    aws_s3_bucket_public_access_block.nextjs_bucket_block_public_access,
  ]

  bucket = aws_s3_bucket.nextjs_bucket.id
  acl = "public-read"
}


# S3 Bucket Policy
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "PublicReadGetObject"
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject",
            Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
        }
    ]
  })
}


# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "nextjs_website_configuration" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}