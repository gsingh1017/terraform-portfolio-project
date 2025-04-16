terraform {
  backend "s3" {
    bucket = "gs-nextjs-tf-website-state"
    key    = "global/s3/terraform.tfstate"
    region = "ca-central-1"
    dynamodb_table = "gs-nextjs-website-table"
  }
}