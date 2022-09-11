# Terraform-AWS-Project


PLEASE CLICK ON EDIT TO SEE PROPERLY


--please note that when you want to use s3 bucket as a remote terraform state file, the s3 bucket and the dynamo db must exist in advance , before terraform init, the section which tells terraform , please connect the state file to the backend > s3 is this section :

terraform {
backend "s3" {
 region = "us-east-1"
 bucket = "examplecom-remote-state-development111"
key = "terraform.tfstate"
dynamodb_table = "terraform-up-and-running-locks111"
}

 }

whenever you will use terraform init, it will connect to this backend and perform updated to the s3 bucket

OR

--you can create the s3 bucket and it's configs + dynamodb table, then comment the section of the terraform back end and deploy the infrastructure , then uncomment this section and send the statefile to the s3 bucket.
