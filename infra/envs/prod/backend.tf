/*
terraform {

  backend "s3" {

    bucket = "hotel-booking-terraform-state"

    key = "prod/terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-locks"

    encrypt = true

  }

}
*/
