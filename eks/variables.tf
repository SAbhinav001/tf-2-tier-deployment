variable "vpc_cidr" {
    type = string
}

variable "pub_subnets_cidr" {
    type = list(string)
}

variable "pvt_subnets_cidr" {
    type = list(string)
}