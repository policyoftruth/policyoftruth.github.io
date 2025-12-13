resource "aws_route53_zone" "primary" {
  name = var.domain_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "pages_a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = var.github_pages_ips
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "3600"
  records = [var.github_pages_cname]
}

resource "aws_route53_record" "txt_spf" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 -all"]
}

resource "aws_route53_record" "mx_null" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = "300"
  records = ["0 ."]
}

output "ns_output" {
  value = aws_route53_zone.primary.name_servers
}
