resource "aws_security_group" "sg" {
  name        = "${var.env}-${var.alb_type}-sg"
  description = "application security group"
  vpc_id      = var.vpc_id



  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.allow_sg_cidr]
  }

  egress {
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

resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.dns_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.alb.dns_name]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
