resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = base64encode("#!/bin/bash\necho Hello World > /var/www/html/index.html")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-instance"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_autoscaling_group" "app" {
  name                      = "app-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "app-asg"
    propagate_at_launch = true
  }
}