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

resource "aws_security_group" "SG_Jenkins_WEB_SSH" {
  name        = "SG_Jenkins_WEB_SSH"
  description = "Allow Jenkins UI access"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "Security Group For Jenkins WEB access"
  }
}

resource "aws_ebs_volume" "ebs_volume_permanent" {
    availability_zone = "${var.region}a"
    size = 10
    type = "gp2"
    tags = {
        Name = "Permanent Storage"
    }
}

resource "aws_ebs_snapshot" "ebs_snapshot_permanent" {
  volume_id = aws_ebs_volume.ebs_volume_permanent.id

  tags = {
    Name = "Permanent storage snapshot"
  }
}


output "aws_ebs_snapshot_ids" {
  value = aws_ebs_snapshot.ebs_snapshot_permanent.id
}
output "aws_security_group_ids" {
  value = aws_security_group.SG_Jenkins_WEB_SSH.id

}