variable "environment" {
  description = "Environment name used to select config/<environment>.yaml."
  type        = string
  default     = "testing"
}

variable "config_file" {
  description = "Optional path to a YAML configuration file."
  type        = string
  default     = null
}
