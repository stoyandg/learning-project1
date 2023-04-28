data "aws_iam_policy" "ec2_to_aurora_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role" "ec2_to_aurora_role" {
  name = "${var.app_name}_ec2_to_aurora_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_to_aurora_policy-attachment" {
  policy_arn = data.aws_iam_policy.ec2_to_aurora_policy.arn
  role       = aws_iam_role.ec2_to_aurora_role.name
}

resource "aws_iam_instance_profile" "ec2_to_aurora_profile" {
  name = "${var.app_name}_ec2_to_aurora_profile"
  role = aws_iam_role.ec2_to_aurora_role.name
}
