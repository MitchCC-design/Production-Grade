resource "aws_iam_role" "ec2" {
  name = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2-policy"
  role = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.ec2_policy.json
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "alb" {
  name = "alb-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume.json
}

data "aws_iam_policy_document" "alb_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticloadbalancing.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "terraform" {
  name = "terraform-role"
  assume_role_policy = data.aws_iam_policy_document.terraform_assume.json
}

data "aws_iam_policy_document" "terraform_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}