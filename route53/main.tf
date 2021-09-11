resource "aws_route53_zone" "primary" {
  name = var.domain_name
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
