resource "aws_elb" "backend_lb" {
  name = "backend_lb"
  security_groups = [
    "${aws_security_group.lbsecuritygroupB.id}"
  ]
  subnets = [
    "${aws_subnet.cloudforce_privateA.id}",
    "${aws_subnet.cloudforce_privateB.id}"
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
