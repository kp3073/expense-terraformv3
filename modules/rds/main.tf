resource "aws_security_group" "main" {
  name        = "${var.env}-${var.componant}-sg"
  description = "application security group"
  vpc_id      = var.vpc_id



  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.componant}-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-${var.componant} -sbgroup"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.env}-${var.componant} -sbgroup"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.3"
  db_subnet_group_name = aws_db_subnet_group.main.name
  database_name           = "dummy"
  master_username         = data.aws_ssm_parameter.master_username.value
  master_password         = data.aws_ssm_parameter.master_password.value
  skip_final_snapshot = true
}


resource "aws_rds_cluster_instance" "main" {
  count              = 1
  identifier         = "${var.env}-${var.componant}-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.r4.large"
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
}