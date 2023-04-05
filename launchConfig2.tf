resource "aws_launch_configuration" "backend" {
  name_prefix = "web-"
image_id = "ami-0557a15b87f6559cf" 
  instance_type = "t2.micro"
security_groups = [ "${aws_security_group.instancesg.id}" ]
  associate_public_ip_address = true
  user_data = "${file("backenddata.sh")}"
lifecycle {
    create_before_destroy = true
  }
}
