resource "aws_launch_template" "frontend" {
  name_prefix = "frontend"
  image_id = "ami-0557a15b87f6559cf" 
  instance_type = "t2.micro"
  network_interfaces {
    security_groups = [ "${aws_security_group.instancesg.id}" ]

    associate_public_ip_address = true
  }
  
  user_data = "${base64encode(file("frontenddata.sh"))}"
  lifecycle {
      create_before_destroy = true
    }
}
