locals {
  bucket_names = ["my-bucket-for-1-snk",
  "my-bucket-for-2-snk",
  "my-bucket-for-3-snk"]
}

module "for_loops" {
  for_each = { for name in local.bucket_names : name => name }
  source = "./modules/s3"
  
  is_website     = false
  bucket_name    = each.value
}

/* {
  each.key              - each.value
  "my-bucket-for-1-snk" = "my-bucket-for-1-snk"
  "my-bucket-for-2-snk" = "my-bucket-for-2-snk"
  "my-bucket-for-3-snk" = "my-bucket-for-3-snk"
} */