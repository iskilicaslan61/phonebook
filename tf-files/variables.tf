variable "key_name" {
    type        = string
    description = "AWS EC2 Key Pair name for SSH access"
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "instance_type" {
    type        = string
    description = "EC2 instance type"
    default     = "t2.micro"
}

variable "git-name" {
    type        = string
    description = "GitHub username to clone private repo"
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "record-name" {
    type        = string
    description = "Route53 record name (optional)"
    default     = "phonebook" # e.g., phonebook.example.com
}

variable "hosted-zone" {
    type        = string
    description = "Route53 hosted zone name without trailing dot (e.g., example.com)"
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "db-name" {
    type        = string
    description = "RDS database name"
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "db-user" {
    type        = string
    description = "RDS master username"
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "db-password" {
    type        = string
    description = "RDS master password"
    sensitive   = true # Marks this as sensitive - won't show in logs
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}

variable "git-token" {
    type        = string
    description = "GitHub Personal Access Token"
    sensitive   = true # Marks this as sensitive - won't show in logs
    default     = "" # DO NOT write actual values here - use terraform.tfvars instead
}