resource "aws_security_group" "instancesg" {
  name   = "instancesg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
    cidr_blocks       = ["0.0.0.0/0"]

  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}
