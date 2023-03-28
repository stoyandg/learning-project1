data "aws_iam_policy" "ec2-to-aurora-policy" {
  arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role" "ec2-to-aurora-role" {
  name = "${var.app-name}-ec2-to-aurora-role"

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

resource "aws_iam_role_policy_attachment" "ec2-to-aurora-policy-attachment" {
  policy_arn = data.aws_iam_policy.ec2-to-aurora-policy.arn
  role       = aws_iam_role.ec2-to-aurora-role.name
}

resource "aws_iam_instance_profile" "ec2-to-aurora-profile" {
  name = "${var.app-name}-ec2-to-aurora-profile"
  role = aws_iam_role.ec2-to-aurora-role.name
}