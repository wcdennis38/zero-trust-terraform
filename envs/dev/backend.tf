terraform {
  backend "s3" {
    bucket = "tf-state-zero-trust-150460248370"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
