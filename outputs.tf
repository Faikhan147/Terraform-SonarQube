output "sonarqube_public_ip" {
  description = "Public IP of the SonarQube EC2 instance"
  value       = aws_instance.this.public_ip
}

output "sonarqube_instance_id" {
  description = "Instance ID of the SonarQube EC2"
  value       = aws_instance.this.id
}
