# How to use

```terraform
module "private_buckets"{
  count          = length(var.private_buckets)
  source         = "../modules/s3"
  is_website     = false
  bucket_name    = var.private_buckets[count.index]
}
```
