resource "aws_autoscaling_group" "frontendASG" {
  name     = "frontendASG"
  min_size = 2
  max_size = 6

  health_check_type = "EC2"

  vpc_zone_identifier = [
    aws_subnet.cloudforce_publicA.id,
    aws_subnet.cloudforce_publicB.id
  ]

  target_group_arns = [aws_lb_target_group.frontendTG.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.frontend.id
      }
      
    }
  }
}

resource "aws_autoscaling_policy" "asgpolicy" {
  name                   = "asgpolicy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontendASG.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 25.0
  }
}
