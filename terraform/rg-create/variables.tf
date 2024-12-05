variable "region" {
  type = string
  default = "West Europe"
}

variable "group-name" {
  type = string
}

variable "amount" {
  type = number
  default = 1
}

variable "tags" {
  type = map(string)
  default = {
    "author": "terraform"
  }
}