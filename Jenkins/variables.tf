variable "vpc_cidr" {
    type = string
}
variable "pub_subnets_cidr" {
    type = list(string)
}

variable "instance_type" {
  type = string
}
