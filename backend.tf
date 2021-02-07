terraform {
  backend "s3" {
    bucket = "nulldiv-web-tf"
    key    = "state/tfstate.state"
    region = "us-east-1"
  }
}
