resource "aws_iam_role" "K8sRole" {
  name = "K8sRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "K3sProfile" {
  name = "K3sProfile"
  role = aws_iam_role.K8sRole.name
}

resource "aws_iam_role_policy_attachment" "EC2FullAccess" {
  role       = aws_iam_role.K8sRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "S3ReadOnlyAccess" {
  role       = aws_iam_role.K8sRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ECRReadOnlyAccess" {
  role       = aws_iam_role.K8sRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAccess" {
  role       = aws_iam_role.K8sRole.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
