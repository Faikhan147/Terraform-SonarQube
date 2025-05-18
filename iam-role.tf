# Role creation of sonarqube-ssm-access

resource "aws_iam_role" "sonarqube_ssm_role" {
  name = var.sonarqube_ssm_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Default policy AmazonSSMManagedInstanceCore attached to Role sonarqube-ssm-access

resource "aws_iam_role_policy_attachment" "attach_ssm_access" {
  role       = aws_iam_role.sonarqube_ssm_role.name
  policy_arn = var.AmazonSSMManagedInstanceCore_arn
}

# Instance profile creation for sonarqube-ssm-access attach to SonarQube EC2

resource "aws_iam_instance_profile" "sonarqube_ssm_profile" {
  name = var.sonarqube_ssm_role_name
  role = aws_iam_role.sonarqube_ssm_role.name
}
