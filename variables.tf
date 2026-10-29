variable "name" {
  description = "Resource name. Lowercase letters, digits and hyphens."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.name))
    error_message = "name must match ^[a-z0-9-]{1,63}$."
  }
}

variable "context" {
  description = "Deployment context used for naming, tagging and environment-dependent defaults."
  type = object({
    organization = string
    environment  = string
    application  = string
    component    = optional(string)
    owner        = string
    cost_center  = string
    extra_tags   = optional(map(string), {})
  })
  validation {
    condition     = contains(["dev", "staging", "prod", "test", "shared"], var.context.environment)
    error_message = "context.environment must be one of dev, staging, prod, test, shared."
  }
}

variable "create" {
  description = "Whether to create any resources. Set false to create nothing."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC the subnet belongs to."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block of the subnet. Must fall inside the VPC CIDR."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone" {
  description = "Availability zone of the subnet, for example us-west-2a."
  type        = string
}

variable "route_table_id" {
  description = "Route table to associate with the subnet. Null creates no association, so the subnet uses the VPC main route table."
  type        = string
  default     = null
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in the subnet get a public IP by default. Defaults to false; request a public IP explicitly where one is needed."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags merged onto every taggable resource, applied last."
  type        = map(string)
  default     = {}
}
