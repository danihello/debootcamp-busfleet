provider "aws" {
  region = var.aws_region
}

# Create a VPC for RDS (optional if you want to use an existing VPC)
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow inbound traffic for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS instance
resource "aws_db_instance" "postgres" {
  allocated_storage    = var.allocated_storage
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

  # Set max_allocated_storage to prevent storage autoscaling
  max_allocated_storage = var.allocated_storage

  # Optionally, define backups and maintenance
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
}

# Create a DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.main.id]
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_password" {
  value     = aws_db_instance.postgres.password
  sensitive = true
}
