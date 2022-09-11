# Terraform-AWS-Project


PLEASE CLICK ON EDIT TO SEE PROPERLY

--first cd in the remote state folder and create the s3 bucket + dynamo db 
--second use the normal base.tf file and note that the section of remote backend "s3" is uncommented 

--please note that when you want to use s3 bucket as a remote terraform state file, the s3 bucket and the dynamo db must exist in advance , before terraform init, the section which tells terraform , please connect the state file to the backend > s3 is this section :

terraform {
backend "s3" {
 region = "us-east-1"
 bucket = "examplecom-remote-state-development111"
key = "terraform.tfstate"
dynamodb_table = "terraform-up-and-running-locks111"
}

 }

whenever you will use terraform init, it will connect to this backend and perform updated to the s3 bucket and every change will update the s3 remote state file automatically 

--note :
The terraform state pull command is used to manually download and output the state from remote state. This command also works with local state.

The terraform state push command is used to manually upload a local state file to remote state. This command also works with local state

--note :
Terraform local values (or "locals") is just as a nick name to an expression , so we can use this name later in a tag or something

example:

locals {
  name_suffix = "${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
}

 module "vpc" {
   source  = "terraform-aws-modules/vpc/aws"
   version = "2.66.0"

   name = "vpc-${local.name_suffix}"        <<<<<
   ## ...
 }
