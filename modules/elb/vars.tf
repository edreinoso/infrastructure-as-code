variable "elb-name" {
  type    = "string"
  default = ""

  # type    = "list"
  # default = []
}

variable "elb-type" {
  type    = "string"
  default = ""
}

variable "internal-elb" {
  type    = "string"
  default = ""
}

variable "subnet-ids" {
  # type    = "string"
  # default = ""
  type    = "list"
  default = []
}

variable "security-group" {
  type    = "list"
  default = []
}

variable "vpc-id" {
  type    = "string"
  default = ""
}

variable "bucket-name" {
  type    = "string"
  default = ""
}

variable "template" {
  type = "string"
  default = ""
}