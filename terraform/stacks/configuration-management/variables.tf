variable "environment" {
  description = "Environment used to select environments/<environment>/<environment>.yaml."
  type        = string
  default     = "nonproduction"

  validation {
    condition     = contains(["nonproduction", "production"], var.environment)
    error_message = "Environment must be nonproduction or production."
  }
}

variable "config_file" {
  description = "Optional path to a YAML configuration file."
  type        = string
  default     = null
}
