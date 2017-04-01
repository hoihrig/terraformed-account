output "ELB_DNS" {
  value = "${aws_elb.web.dns_name}"
}