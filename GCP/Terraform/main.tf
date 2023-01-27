# Torq - Runner Host Automation Template
# Joe Dillig - joe.dillig@torq.io
# GCP Provider: https://registry.terraform.io/providers/hashicorp/google/latest/docs

provider "google" {
  region      = var.cloud_region
}

resource "google_compute_instance" "default" {
  name         = "Torq Runner"
  machine_type = "f1.micro"

  tags = ["torq"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    subnetwork = "default"
  }

  metadata = {
    vm = "tf"
  }

  metadata_startup_script = "${data.template_file.userdata.rendered}"

}

#Security Group/Firewall
resource "google_compute_firewall" "ssh" {
  name = "torq-runner-sg"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = var.virtual_network
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
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

#---------------------

resource "aws_instance" "torq-runner" {
  count = var.instance_count
  ami = "ami-0b5eea76982371e91" #Amazon Linux 2 x86
  key_name = var.ssh_keypair
  instance_type = var.instance_size
  subnet_id = var.virtual_subnet
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  user_data = "${data.template_file.userdata.rendered}"
    tags = {
      Name = "Torq Runner"
    }
}
