resource "aws_elb" "frontend_lb" {
  name = "frontend_lb"
  security_groups = [
    "${aws_security_group.lbsecuritygroupF.id}"
  ]
  subnets = [
    "${aws_subnet.cloudforce_publicA.id}",
    "${aws_subnet.cloudforce_publicB.id}"
  ]
cross_zone_load_balancing   = true
health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}
