terraform {

  # terraform with s3 backend

  backend "s3" {
    bucket         = "ghw-statefiles" # existing bucket name
    key            = "ecs-wordpress"  # identifier key as a file path
    region         = "us-east-1"      # region
    dynamodb_table = "statelock"
  }
}


