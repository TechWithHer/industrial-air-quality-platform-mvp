variable "raw_bucket_name" {
  type    = string
  default = "iaqap-dev-raw"
}

variable "processed_bucket_name" {
  type    = string
  default = "iaqap-dev-processed"
}

variable "athena_results_bucket_name" {
  type    = string
  default = "iaqap-dev-athena-results"
}
variable "aws_region" {
  description = "AWS Region"

  type = string

  default = "ap-southeast-1"
}
