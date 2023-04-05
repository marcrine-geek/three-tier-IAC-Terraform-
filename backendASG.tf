resource "aws_autoscaling_group" "backendasg" {
  name = "${aws_launch_configuration.backend.name}-asg"
  min_size             = 2
  desired_capacity     = 6
  max_size             = 4
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.backend_lb.id}"
  ]
launch_configuration = "${aws_launch_configuration.backend.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
    "${aws_subnet.cloudforce_privateA.id}",
    "${aws_subnet.cloudforce_privateB.id}"
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tag {
    key                 = "Name"
    value               = "backendasg"
    propagate_at_launch = true
  }
}
