terraform {
  backend "s3" {
    bucket       = "iaqap-dev-tf-state"
    key          = "dev/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}
