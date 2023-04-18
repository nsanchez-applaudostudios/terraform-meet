provider "aws" {
  region  = var.aws_region
  profile = var.environment == "prod" ? var.profile_prod : var.profile_dev
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = "Terraform-dev"
      Project     = var.project_name
    }
  }
}
# profile use access key where we have to deploy resources
