terraform {
  backend "s3" {
    bucket         = "terraform-backend-faisal-khan"
    key            = "sonarqube/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
