variable "domain_name" {
  type        = string
  description = "The primary domain name for the website (e.g. example.com)"
}

variable "github_pages_cname" {
  type        = string
  description = "The CNAME target for the www subdomain (e.g. username.github.io.)"
}

variable "github_pages_ips" {
  type        = list(string)
  description = "The list of IP addresses for GitHub Pages A records"
}
