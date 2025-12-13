variable "domain_name" {
  type        = string
  description = "The primary domain name for the website (e.g. example.com)"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources into"
}
