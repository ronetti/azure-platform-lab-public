variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
