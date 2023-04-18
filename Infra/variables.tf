/* GLOBALS  */

variable "profile_dev" {
  default     = "limimonsters"
  description = "Configure aws console for dev"
}

variable "profile_prod" {
  default     = "limimonsters"
  description = "Configure aws console for dev"
}

variable "environment" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "infinity"
}