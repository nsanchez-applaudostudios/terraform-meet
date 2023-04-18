variable "bucket_name"    { }
variable "is_website"     { default = false }
variable "index_document" { default = "index.html" }
variable "error_document" { default = "index.html" }
variable "acl"            { default = "private" }
variable "cors_rule"      { default = [] }
variable "bucket_policy"  { default = {} }
variable "force_destroy"  { default = false }

module "bucket"{
  count       = var.is_website == false ? 1 : 0 
  source      = "./normal-bucket"
  bucket_name = var.bucket_name
  acl         = var.acl
  cors_rule   = var.cors_rule
  bucket_policy  = var.bucket_policy
  force_destroy = var.force_destroy
}

module "bucket_site"{
  count          = var.is_website == true ? 1 : 0 
  source         = "./web-site"
  bucket_name    = var.bucket_name
  index_document = var.index_document
  error_document = var.error_document
  acl            = var.acl
  bucket_policy  = var.bucket_policy
}

output "id"                           { value = var.is_website == false ? module.bucket[0].id : module.bucket_site[0].id }
output "arn"                          { value = var.is_website == false ? module.bucket[0].arn : module.bucket_site[0].arn }
output "bucket_domain_name"           { value = var.is_website == true  ? module.bucket_site[0].bucket_domain_name : module.bucket[0].bucket_domain_name }
output "bucket_regional_domain_name"  { value = var.is_website == true  ? module.bucket_site[0].bucket_regional_domain_name : module.bucket[0].bucket_regional_domain_name }
output "website_endpoint"             { value = var.is_website == true  ? module.bucket_site[0].website_endpoint : null }
output "hosted_zone_id"               { value = var.is_website == true  ? module.bucket_site[0].hosted_zone_id : module.bucket[0].hosted_zone_id }
