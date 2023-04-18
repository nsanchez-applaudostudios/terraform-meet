variable "bucket_name"    { }
variable "index_document" { default = "index.html" }
variable "error_document" { default = "index.html" }
variable "acl"            { default = "public-read" }
variable "bucket_policy"  { default = {} }

resource "aws_s3_bucket" "bucket_site" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "bucket_site" {
  bucket = aws_s3_bucket.bucket_site.id
  acl    = var.acl
}


resource "aws_s3_bucket_policy" "bucket_site" {
  count  = var.bucket_policy != {} ? 1 : 0
  bucket = aws_s3_bucket.bucket_site.id
  policy = jsonencode(var.bucket_policy)
}

resource "aws_s3_bucket_website_configuration" "bucket_site" {
  bucket = aws_s3_bucket.bucket_site.id

  index_document {
    suffix =  var.index_document
  }

  error_document {
    key    = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  count  = var.acl == "private" ?  1 : 0
  bucket = aws_s3_bucket.bucket_site.id
  
  block_public_acls       = true  # Block new public ACLs and uploading public objects
  ignore_public_acls      = true  # Retroactively remove public access granted through public ACLs
  block_public_policy     = true  # Block new public bucket policies
  restrict_public_buckets = true  # Retroactivley block public and cross-account access if bucket has public policies
}

output "id"                           { value = aws_s3_bucket.bucket_site.id }
output "arn"                          { value = aws_s3_bucket.bucket_site.arn }
output "bucket_domain_name"           { value = aws_s3_bucket.bucket_site.bucket_domain_name }
output "bucket_regional_domain_name"  { value = aws_s3_bucket.bucket_site.bucket_regional_domain_name }
output "website_endpoint"             { value = aws_s3_bucket_website_configuration.bucket_site.website_endpoint }
output "hosted_zone_id"               { value = aws_s3_bucket.bucket_site.hosted_zone_id }
