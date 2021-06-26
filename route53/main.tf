variable "domain_name" {
  type = string
  default = "winningham.me"
}

variable "k8s_sub" {
  type = string
  default = "k8s.winningham.me"
}

variable "aws_region" {
  type = string
  default  = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_zone" "k8s" {
  name = var.k8s_sub
}

resource "aws_route53_record" "domain_ns" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 300
  type            = "NS"
  zone_id         = aws_route53_zone.primary.zone_id

  records = [
    aws_route53_zone.primary.name_servers[0],
    aws_route53_zone.primary.name_servers[1],
    aws_route53_zone.primary.name_servers[2],
    aws_route53_zone.primary.name_servers[3],
  ]
}

resource "aws_route53_record" "pages_a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "3600"
  records = ["policyoftruth.github.io"]
}

output "ns_output" {
  value = aws_route53_zone.primary.name_servers
}

resource "aws_route53_record" "k8s_domain_ns" {
  allow_overwrite = true
  name            = var.k8s_sub
  ttl             = 300
  type            = "NS"
  zone_id         = aws_route53_zone.primary.zone_id

  records = [
    aws_route53_zone.k8s.name_servers[0],
    aws_route53_zone.k8s.name_servers[1],
    aws_route53_zone.k8s.name_servers[2],
    aws_route53_zone.k8s.name_servers[3],
  ]
}

output "k8s_ns_output" {
  value = aws_route53_zone.k8s.name_servers
}
