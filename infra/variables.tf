variable "app_name" {
  description = "application name"
  type        = string
  default     = "chatbot"
}

variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-northeast-1"
}

variable "image_name" {
  description = "application name"
  type        = string
  default     = "chatbot"
}

variable "api_port" {
  description = "api port"
  type        = number
  default     = 3000
}
