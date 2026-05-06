variable "subnet_id" {
  type = string
}

variable "public_ip" {
  type = bool
}

variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}
