resource "aws_autoscaling_group" "frontendasg" {
  name = "${aws_launch_configuration.frontend.name}-asg"
  min_size             = 2
  desired_capacity     = 6
  max_size             = 4
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.frontend_lb.id}"
  ]
launch_configuration = "${aws_launch_configuration.frontend.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
    "${aws_subnet.cloudforce_publicA.id}",
    "${aws_subnet.cloudforce_publicB.id}"
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
    key                 = "Name"
    value               = "frontendasg"
    propagate_at_launch = true
  }
}