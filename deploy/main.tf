variable "region" {
  type = string
  default = "eu-central-1"
}
variable "access_key" {
  type = string
   default = "none"
}
variable "secret_key" {
  type = string
   default = "none"
}
variable "ami_id" {
  type = string
   default = "none"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "jenkins_server" {
  ami = var.ami_id
  instance_type = "t2.micro"
  key_name      = module.ssh_key_pair.key_name
  security_groups = [ 
      "SG_Jenkins_WEB_SSH"
  ]
  tags = {
    Name = "JENKINS SERVER"
  }

}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  name                  = "jenkins_web_server"
  ssh_public_key_path   = "."
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

output "aws_instance_ip" {
  value =  "http://${aws_instance.jenkins_server.public_ip}:8080"
}