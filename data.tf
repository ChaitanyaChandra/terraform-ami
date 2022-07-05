data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "base-with-ansible"
  owners      = ["self"]
}

data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket         = "terraform-nonprod-state-chaitu"
    key            = "terraform_ec2_spot.tfstate"
    region         = "us-east-1"
  }
}