provider "aws" {
region = "${var.region}"
}

module "vpc" {
source = "./vpc"
environment = "${var.environment}"
region = "${var.region}"
key_name = "${var.key_name}"
vpc_cidr = "${var.vpc_cidr}"
public_subnets = var.public_subnets
private_subnets = var.private_subnets
}

resource "aws_security_group" "elb_sg" {
  name        = "security-group-load balancer"
  description = "security-group-load balancer"
  vpc_id      = module.vpc.vpc_id  # we have used the output method in VPC module
ingress { 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
 tags = {
    Name = "SG-load balancer"
    Project = "demo-assignment" 
  } 
}
# Create security group for webserver 
resource "aws_security_group" "webserver_sg" {
  name        = "security group-Ec2"
  description = "security-group-EC2"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
   }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "security-group-EC2" 
    Project = "demo-assignment"
  }
}

#Create Launch config
resource "aws_launch_configuration" "webserver-launch-config" {
  name_prefix   = "webserver-launch-config"
  image_id      =  var.ami[var.region]
  instance_type = "t2.micro"
  key_name = var.key_name
  security_groups = ["${aws_security_group.webserver_sg.id}"] 
  
  root_block_device {
            volume_type = "gp2"
            volume_size = 10
            encrypted   = true
        }
  # ebs_block_device {
  #           device_name = "/dev/sdf"
  #           volume_type = "gp2"
  #           volume_size = 5
  #           encrypted   = true
  #       }
lifecycle {
        create_before_destroy = true
     }
   user_data  = file("web_bootstrap.sh")
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "Demo-scalling-group" {
  name       = "Demo-ASG-tf"
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1
  force_delete       = true
  depends_on         = [aws_lb.ALB-tf]
  target_group_arns  =  ["${aws_lb_target_group.TG-tf.arn}"]
  health_check_type  = "EC2"
  launch_configuration = aws_launch_configuration.webserver-launch-config.name
  vpc_zone_identifier = module.vpc.private_subnet_ids 
  
 tag {
       key                 = "Name"
       value               = "Demo-Scalling-g"
       propagate_at_launch = true
    }
}

# Create Target group
resource "aws_lb_target_group" "TG-tf" {
  name     = "Demo-TargetGroup-tf"
  depends_on = [module.vpc.vpc_id] #en el VPC tkon hslaha create
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60 
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

# Create ALB
resource "aws_lb" "ALB-tf" {
   name              = "Demo-ALG-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups  = [aws_security_group.elb_sg.id]
  subnets          = module.vpc.public_subnet_ids   
  tags = {
        name  = "Demo-AppLoadBalancer-tf"
        Project = "demo-assignment"
       }
}
# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-tf.arn
  }
}

# #outputs from the vpc module
# output "public_subnet_ids" {
# value = ["${module.vpc.public_subnet_ids}"]
# }
# output "private_subnet_ids" {
# value = ["${module.vpc.private_subnet_ids}"]
# }

# # terraform {
# # backend "s3" {
# # region = "us-east-1"
# # bucket = "examplecom-remote-state-development111"
# # key = "terraform.tfstate"
# # }
# # }
