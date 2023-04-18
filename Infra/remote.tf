terraform {
  backend "s3" {
    bucket  = "nelson-infra-status"
    key     = "meet.tfstate"
    region  = "us-east-1"
    profile = "limimonsters"

    dynamodb_table = "TerraformLock"
  }
}
# profile we have to use access key for father account
#LockID 