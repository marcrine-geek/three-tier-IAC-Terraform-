resource "aws_security_group" "instancesg" {
  name   = "instancesg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lbsecuritygroupB.id]
  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}
