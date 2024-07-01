resource "aws_security_group" "sg" {
  name        = "${var.env}-${var.alb_type}-sg"
  description = "application security group"
  vpc_id      = var.vpc_id



  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.allow_sg_cidr]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.alb_type}"
  }
}

resource "aws_lb" "alb" {
  name               = "${var.env}-${var.alb_type}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = var.subnet

  tags = {
    Environment = "${var.env}-${var.alb_type}"
  }
}