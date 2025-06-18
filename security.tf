resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS from the world"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "alb-sg" }
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "ec2-sg" }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow DB access from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "rds-sg" }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id
  )
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = { Name = "main-nacl" }
}

resource "aws_kms_key" "s3_kms_key" {
  description = "KMS key for S3 encryption"
  key_usage   = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 10
}

resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key for RDS encryption"
  key_usage   = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "assets" {
  bucket = "my-assets-bucket"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_kms_key.id
      }
    }
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "my-postgres-db"
  engine     = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_kms_key.id
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}