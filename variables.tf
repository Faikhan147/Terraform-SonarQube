variable "ami_id" {
  description = "AMI ID for the SonarQube instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "volume_size" {
  description = "Size of the root EBS volume"
  type        = number
}

variable "volume_type" {
  description = "Type of the root EBS volume"
  type        = string
}

variable "sonarqube_ssm_role_name" {
  description = "IAM Role name for SonarQube ssm access"
  type        = string
}

variable "AmazonSSMManagedInstanceCore_arn" {
  description = "ARN of the policy to allow SSM access"
  type        = string
}
