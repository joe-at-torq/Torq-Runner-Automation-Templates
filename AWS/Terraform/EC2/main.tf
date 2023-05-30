# Torq - Runner Host Automation Template
# Joe Dillig - joe.dillig@torq.io
# AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region = var.cloud_region
}

resource "aws_instance" "torq-runner" {
  count = var.instance_count
  ami = "ami-0b5eea76982371e91" #Amazon Linux 2 x86
  associate_public_ip_address = true #Assign a public elastic ip address
  key_name = var.ssh_keypair
  instance_type = var.instance_size
  subnet_id = var.virtual_subnet
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  user_data = "${data.template_file.userdata.rendered}"
    tags = {
      Name = "Torq Runner"
    }
}

resource "aws_security_group" "websg" {
  name = "torq-runner-sg"
  description = "Torq Runner Host Security Group"
  vpc_id = var.virtual_network
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    tags = {
      Name = "torq"
    }
}

#Userdata Template
data "template_file" "userdata" {
  template = "${file("runner_host_userdata.sh")}"
  vars = {
    torq_runner_url = "${var.torq_runner_url}"
    }

}

#Render Userdata Template
resource "local_file" "userdata_rendered" {
    content     = "${data.template_file.userdata.rendered}"
    filename = "userdata_rendered.sh"
}