output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "ec2_instance_ids" {
  value = aws_instance.app.*.id
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.main.name
}