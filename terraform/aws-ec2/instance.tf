locals {
  # TODO: use aws_ami data to find the AMI
  ami_id = "ami-08b6a2983df6e9e25" # Amazon Linux 2023 AMI 2023.9.20251117.1 x86_64 HVM kernel-6.1
}

data "aws_key_pair" "main" {
  key_name = "main"
}

resource "aws_instance" "example_http_instance" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  security_groups = [
    aws_security_group.allow_http_and_ssh_in_all_out.name
  ]
  key_name                    = data.aws_key_pair.main.key_name
  user_data                   = file("instance_user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "Example HTTP server"
  }
}
