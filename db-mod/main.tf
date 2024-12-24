resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet_${var.name}"
  subnet_ids = flatten([var.private_subnet_cidrs])

  tags = {
    Name = var.name
  }
}

resource "random_password" "root_password" {
  length           = 64
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_security_group" "rds" {
  name   = "db_sg_${var.name}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = flatten([var.private_subnet_cidrs, var.public_subnet_cidrs])
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = flatten([var.private_subnet_cidrs, var.public_subnet_cidrs])
  }

  tags = {
    Name = var.name
  }
}

resource "aws_db_parameter_group" "db_params" {
  name   = "dbparams${var.name}"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "db" {
  identifier             = "db-${var.name}"
  instance_class         = "db.t3.medium"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "16.2"
  username               = "${var.name}_root_user"
  password               = random_password.root_password.result
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_params.name
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = var.name
  }
}
