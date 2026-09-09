# FIXTURE: intentionally vulnerable.

resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "recyf-lab-vpc" }
}
# No aws_flow_log: intentional

resource "aws_security_group" "wide_open" {
  name        = "recyf-lab-open"
  description = "Deliberately permissive lab fixture"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from the entire internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP from the entire internet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "unencrypted" {
  availability_zone = "${var.region}a"
  size              = 1
  encrypted         = false
}
