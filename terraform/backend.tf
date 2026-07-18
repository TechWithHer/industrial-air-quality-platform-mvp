terraform {
  backend "s3" {
    bucket         = "iaqap-dev-tf-state"
    key            = "iaqap/iaqap-dev-tf-state"
    region         = "ap-southeast-1"
    use_lockfile   = true
  }
}
