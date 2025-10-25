terraform {
  backend "s3" {
    bucket         = "terraform-backend-all-environments"
    key            = "sonarqube/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "terraform-locks-sonarqube"
  }
}
