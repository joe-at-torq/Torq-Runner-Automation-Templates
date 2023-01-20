variable "cloud_region" {
  description = "Public cloud region to build runner host vm."
  type = string
  default     = "us-east-1"
}

variable "instance_size" {
  description = "Compute size of the runner host vm."
  type = string
  default     = "t2.medium"
}

variable "instance_count" {
  description = "Number of virtual machine runners. This can be used for deploying redundant or load-shared runners."
  type = number
  default = 1
}

variable "virtual_network" {
  description = "Virtual network id (VPC/VNET)"
  type = string
  default     = "vpc-036b8f**********"
}

variable "virtual_subnet" {
  description = "Virtual subnet id"
  type = string
  default     = "subnet-00121eecd*********"
}

variable "ssh_keypair" {
  description = "The name of the SSH key to assign to the virtual host."
  type = string
  default     = "***********"
}

variable "torq_runner_url" {
  description = "The url given when creating a Docker runner."
  type = string
  default     = "https://link.torq.io/exampleurl"
}