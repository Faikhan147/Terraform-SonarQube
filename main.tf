resource "aws_instance" "sonarqube_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.sonarqube_ssm_profile.name

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data = file("${path.module}/setup_sonarqube.sh")

  tags = {
    Name = "SonarQube-Machine"
  }
}
