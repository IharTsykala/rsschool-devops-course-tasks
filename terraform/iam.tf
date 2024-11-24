resource "aws_iam_role" "JenkinsRole" {
  name = "JenkinsRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "JenkinsProfile" {
  name = "JenkinsProfile"
  role = aws_iam_role.JenkinsRole.name
}

resource "aws_iam_role_policy_attachment" "EC2FullAccess" {
  role       = aws_iam_role.JenkinsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "S3FullAccess" {
  role       = aws_iam_role.JenkinsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "VPCFullAccess" {
  role       = aws_iam_role.JenkinsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "IAMFullAccess" {
  role       = aws_iam_role.JenkinsRole.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "ECRFullAccess" {
  role       = aws_iam_role.JenkinsRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
#   role       = aws_iam_role.JenkinsRole.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }
