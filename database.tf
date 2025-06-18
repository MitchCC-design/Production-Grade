resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = { Name = "main-db-subnet-group" }
}

resource "aws_db_parameter_group" "main" {
  name   = "main-db-params"
  family = "postgres15"
  parameter {
    name  = "max_connections"
    value = "100"
  }
  tags = { Name = "main-db-params" }
}

resource "aws_kms_key" "rds" {
  description = "KMS key for RDS"
}

resource "aws_db_instance" "postgres" {
  identifier              = "main-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  parameter_group_name    = aws_db_parameter_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds.arn
  skip_final_snapshot     = true
  publicly_accessible     = false
  tags = { Name = "main-postgres" }
}