variable "vpc-cidr" {
  type    = "string"
  default = ""
}

variable "enable-dns-hostname" {
  type    = "string"
  default = ""
}

variable "enable-dns-support" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}

#TAGS: to be deprecated
# variable "vpc-name" {
#   type    = "string"
#   default = ""
# }

# variable "template" {
#   type = "string"
#   default = ""
# }

# variable "application" {
#   type = "string"
#   default = ""
# }

# variable "purpose" {
#   type = "string"
#   default = ""
# }

# variable "environment" {
#   type    = "string"
#   default = ""
# }

# variable "created-on" {
#   type = "string"
#   default = ""
# }