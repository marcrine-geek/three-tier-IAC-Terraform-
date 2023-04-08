resource "aws_lb" "backend_lb" {
  name               = "backend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lbsecuritygroupB.id]

  subnets = [
    aws_subnet.cloudforce_privateA.id,
    aws_subnet.cloudforce_privateB.id
  ]
}

resource "aws_lb_target_group" "backendTG" {
  name     = "backendTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudforce_vpc.id

  health_check {
    enabled             = true
    port                = 80
    interval            = 240
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "backendListener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backendTG.arn
  }
}

