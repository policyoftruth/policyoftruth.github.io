remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "nulldiv-web-tf"
    key = "${path_relative_to_include()}/state/tfstate.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
