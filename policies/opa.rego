package policies

deny_open_ports[{"msg": msg}] {
    input.resource_type == "aws_security_group"
    port := input.port
    msg := sprintf("Security group allows open port: %d", [port])
    port == 0
}

require_encryption[{"msg": msg}] {
    input.resource_type == "aws_s3_bucket"
    msg := "S3 bucket must have encryption enabled"
    not input.encryption
}

require_encryption[{"msg": msg}] {
    input.resource_type == "aws_rds_instance"
    msg := "RDS instance must have encryption enabled"
    not input.storage_encrypted
}