variable "bucket_name"   { }
variable "acl"           { default = "private" }
variable "cors_rule"     { default = [] }
variable "bucket_policy" { default = {} }
variable "force_destroy" { default = false }

locals {
  acl = var.acl == "private" ?  var.acl : "public-read"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name  = var.bucket_name
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  count  = var.cors_rule != [] ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  dynamic "cors_rule" {
  for_each = var.cors_rule
  content {
    allowed_headers = lookup(cors_rule.value, "allowed_headers", ["*"])
    allowed_methods = lookup(cors_rule.value, "allowed_methods", ["GET","HEAD"]) 
    allowed_origins = lookup(cors_rule.value, "allowed_origins", ["*"]) 
    expose_headers  = lookup(cors_rule.value, "expose_headers",  []) 
    max_age_seconds = lookup(cors_rule.value, "max_age_seconds", 3000)
    }
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = local.acl
}

resource "aws_s3_bucket_policy" "bucket_site" {
  count  = var.bucket_policy != {} ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode(var.bucket_policy)
}


resource "aws_s3_bucket_public_access_block" "private" {
  count  = var.acl == "private" ?  1 : 0
  bucket = aws_s3_bucket.bucket.id
  
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

output "id"                           { value = aws_s3_bucket.bucket.id }
output "arn"                          { value = aws_s3_bucket.bucket.arn }
output "bucket_domain_name"           { value = aws_s3_bucket.bucket.bucket_domain_name }
output "bucket_regional_domain_name"  { value = aws_s3_bucket.bucket.bucket_regional_domain_name }
output "hosted_zone_id"               { value = aws_s3_bucket.bucket.hosted_zone_id }