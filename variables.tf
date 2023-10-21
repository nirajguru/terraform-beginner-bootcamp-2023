variable "user_uuid" {
  type        = string
  description = "unique user id"
  default = "5adb9335-897f-4472-8015-1978c71aa7ba"

  validation {
    condition     = can(regex("^\\d+$", var.user_uuid)) || can(regex("^[a-zA-Z0-9_-]{1,}$", var.user_uuid))
    error_message = "The uid variable must be either a numeric UID or a valid string."
  }
}
