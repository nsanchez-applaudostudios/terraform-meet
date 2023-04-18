variable "buckets" {
  type = list(string)
  default = [
    "example-dynamic-1-snk",
    "example-dynamic-2-snk",
    "example-dynamic-3-snk",
  ]
}

resource "aws_s3_bucket" "example" {
  for_each = { for bucket in var.buckets : bucket => bucket }

  bucket = each.value
  acl    = "private"
  
  dynamic "website" {
    for_each = each.key == "example-dynamic-1-snk" ? [true] : []
    content {
      index_document = "index.html"
      error_document = "error.html"
    }
  }
}
