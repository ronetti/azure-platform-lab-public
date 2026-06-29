variable "platform_name" {
  description = "Name of the platform."
  type        = string
  default     = "az-platform-lab"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "testing"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "address_space" {
  description = "Virtual network address space."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnets" {
  description = "Subnet map."
  type        = map(string)
  default = {
    app        = "10.10.1.0/24"
    data       = "10.10.2.0/24"
    ingress    = "10.10.10.0/24"
    management = "10.10.20.0/24"
  }
}

variable "log_retention_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}
