terraform {
  backend "s3" {
    bucket         = "terraform-backend-all-envs"
    key            = "sonarqube/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-sonarqube"
  }
}
