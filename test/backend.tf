terraform {
//  Save state to S3 and DynamoDB
  backend "s3" {
	bucket = "devops-urolime-test"
	key    = "develop/state"
	region = "eu-west-2"
	dynamodb_table = "terraform-develop-test"
  }



  required_version = ">= 0.13.1"

  required_providers {
	aws        = ">= 3.22.0"
	local      = ">= 1.4"
	random     = ">= 2.1"
	kubernetes = "~> 1.11"
  }
}

