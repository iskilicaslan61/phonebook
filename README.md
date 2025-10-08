# Phonebook Web Application

A full-stack phonebook application built with Flask and deployed on AWS using Terraform for Infrastructure as Code (IaC). The application allows users to search, add, update, and delete phone records with a modern web interface.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Infrastructure Details](#infrastructure-details)
- [Project Structure](#project-structure)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)

## 🔍 Overview

This project demonstrates a production-ready web application deployment using modern DevOps practices. The application is a phonebook management system where users can perform CRUD operations on contact records. The entire infrastructure is provisioned using Terraform, featuring high availability and auto-scaling capabilities.

## 🏗️ Architecture

The application is deployed using the following AWS architecture:

```
Internet → Route53 → Application Load Balancer → Auto Scaling Group (EC2 Instances) → RDS MySQL
```

### Key Components:

- **Application Load Balancer (ALB)**: Distributes incoming traffic across multiple EC2 instances
- **Auto Scaling Group**: Automatically scales EC2 instances based on demand (1-3 instances)
- **EC2 Instances**: Host the Flask web application
- **RDS MySQL**: Managed database service for storing phonebook records
- **Route53**: DNS management for custom domain
- **VPC & Security Groups**: Network isolation and security controls

## ✨ Features

- **Search Contacts**: Find phonebook entries by name
- **Add Contacts**: Insert new contact records with validation
- **Update Contacts**: Modify existing contact information
- **Delete Contacts**: Remove contacts from the phonebook
- **Input Validation**: Ensures data integrity
- **Responsive UI**: Modern web interface
- **High Availability**: Auto-scaling and load balancing
- **Automated Deployment**: Infrastructure as Code with Terraform

## 🛠️ Technologies

### Application Stack:
- **Python 3.x** - Backend programming language
- **Flask 2.3.3** - Web framework
- **MySQL** - Database
- **HTML/CSS** - Frontend

### Infrastructure:
- **Terraform** - Infrastructure as Code
- **AWS** - Cloud provider
  - EC2 (Amazon Linux 2023)
  - RDS (MySQL 8.0.37)
  - Application Load Balancer
  - Auto Scaling Group
  - Route53
  - VPC & Security Groups
- **Git/GitHub** - Version control

## 📦 Prerequisites

Before you begin, ensure you have the following:

1. **AWS Account** with appropriate permissions
2. **AWS CLI** configured with credentials
3. **Terraform** (v1.0 or later) installed
4. **Git** installed
5. **SSH Key Pair** created in AWS
6. **GitHub Account** with a personal access token
7. **Route53 Hosted Zone** configured

## 🚀 Installation

### Quick Start Summary

```bash
# 1. Clone and navigate to project
git clone https://github.com/YOUR_USERNAME/phonebook.git
cd phonebook/tf-files

# 2. Create your configuration file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your actual values

# 3. Deploy infrastructure
terraform init
terraform plan
terraform apply

# 4. Access your application (wait 2-3 minutes for initialization)
```

### Detailed Installation Steps

### Step 1: Fork or Clone the Repository

**Option A: Fork the Repository (Recommended)**
1. Go to the repository on GitHub
2. Click "Fork" to create your own copy
3. Clone your forked repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/phonebook.git
   cd phonebook
   ```

**Option B: Clone and Create Your Own Repo**
1. Clone this repository
2. Create a new repository on GitHub (can be named anything)
3. Push the code to your new repository
4. Update `terraform.tfvars` with your repository name

**Important:** The EC2 instances will clone the code from YOUR GitHub repository during deployment, so you need your own copy with your modifications.

### Step 2: Configure Variables

**🔒 Secure Configuration Method:**

Create a `terraform.tfvars` file from the provided template:

```bash
cd tf-files
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your actual values:

```hcl
# AWS Configuration
key_name      = "your-actual-key-pair-name"
instance_type = "t2.micro"

# GitHub Configuration
git-name  = "your-github-username"
git-repo  = "phonebook"              # Your repo name (change if you renamed it)
git-token = "ghp_your_github_token_here"

# Route53 Configuration
hosted-zone = "yourdomain.com"

# Database Configuration
db-name     = "phonebook"
db-user     = "admin"
db-password = "YourSecurePassword123"
```

**✅ Security Features Implemented:**

- ✓ All sensitive values are kept in `terraform.tfvars` (already in `.gitignore`)
- ✓ Database credentials are passed as environment variables (not hardcoded)
- ✓ Template file provided for easy setup without exposing secrets
- ✓ No sensitive data committed to Git

### Step 3: Initialize Terraform

```bash
cd tf-files
terraform init
```

### Step 4: Review the Infrastructure Plan

```bash
terraform plan
```

### Step 5: Deploy the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## 📖 Usage

## 🔄 How Repository Cloning Works

When you deploy the infrastructure, here's what happens:

1. **Terraform** reads your `terraform.tfvars` file with your GitHub credentials
2. **EC2 User Data Script** runs during instance launch
3. **Git Clone** downloads the code from YOUR GitHub repository:
   ```bash
   git clone https://$TOKEN@github.com/$USER/$REPO.git
   ```
4. **Application Starts** from the cloned code

**Why You Need Your Own Repository:**
- Each EC2 instance needs to download the application code
- They clone from YOUR GitHub account (specified in `git-name`)
- If you modify the code, instances will get YOUR version
- This allows you to customize the application for your needs

**Repository Name Configuration:**
- Default: `phonebook` (set in `variables.tf`)
- If you rename your repo: Update `git-repo` in `terraform.tfvars`
- Example: If your repo is named `my-phonebook-app`, set `git-repo = "my-phonebook-app"`

### Accessing the Application

After successful deployment, Terraform will output the application URLs:

```bash
# Access via custom domain
websiteurl = "http://phonebook.yourdomain.com"

# Access via ALB DNS name
dns-name = "http://phonebook-lb-xxxxx.us-east-1.elb.amazonaws.com"
```

### Application Endpoints

- **`/`** - Search for contacts
- **`/add`** - Add new contact
- **`/update`** - Update existing contact
- **`/delete`** - Delete contact

### Database Connection

The application automatically connects to the RDS database using environment variables configured in the EC2 user data script.

## 🔧 Infrastructure Details

### Network Configuration

- **Region**: us-east-1
- **VPC**: Default VPC
- **Subnets**: All available subnets in the VPC

### Security Groups

1. **ALB Security Group**
   - Inbound: Port 80 (HTTP) from anywhere
   - Outbound: All traffic

2. **Web Server Security Group**
   - Inbound: Port 80 from ALB, Port 22 (SSH) from anywhere
   - Outbound: All traffic

3. **RDS Security Group**
   - Inbound: Port 3306 from Web Servers only
   - Outbound: All traffic

### Auto Scaling Configuration

- **Desired Capacity**: 1
- **Minimum Size**: 1
- **Maximum Size**: 3
- **Health Check**: ELB with 300s grace period

### RDS Configuration

- **Engine**: MySQL 8.0.37
- **Instance Class**: db.t3.micro
- **Storage**: 20 GB
- **Multi-AZ**: Disabled (can be enabled for production)
- **Backup**: Disabled (can be enabled for production)

## 📁 Project Structure

```
phonebook/
│
├── phonebook-app.py          # Flask application
│
├── templates/                # HTML templates
│   ├── index.html           # Search page
│   ├── add-update.html      # Add/Update page
│   └── delete.html          # Delete page
│
├── tf-files/                # Terraform configuration
│   ├── main.tf             # Main infrastructure resources
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   ├── providers.tf        # Provider configuration
│   ├── sec-gr.tf           # Security groups
│   ├── data.tf             # Data sources
│   └── userdata.sh         # EC2 initialization script
│
├── README.md               # Project documentation
└── .gitignore             # Git ignore rules
```

## 🔒 Security Considerations

### ✅ Security Improvements Implemented:

1. **Environment Variables**: ✓ All database credentials are now loaded from environment variables
   - No hardcoded passwords in application code
   - Credentials passed securely from Terraform to EC2 instances
   - Database host, user, password, and database name all configurable

2. **Terraform Variables**: ✓ Sensitive values protected with `terraform.tfvars`
   - All sensitive data kept in `.gitignore` protected file
   - Template file provided for easy setup without exposing secrets
   - No credentials committed to version control

3. **SQL Injection Protection**: ✓ All database queries now use parameterized queries
   - Replaced f-string formatting with parameter placeholders (%s)
   - All user inputs are safely escaped by the database driver
   - Protected functions: `find_persons()`, `insert_person()`, `update_person()`, `delete_person()`
   - Eliminates risk of SQL injection attacks

### ⚠️ Additional Security Recommendations for Production:

1. **Advanced Secret Management**: For production environments, consider:
   - AWS Secrets Manager for automatic rotation
   - AWS Systems Manager Parameter Store
   - HashiCorp Vault integration

2. **SSH Access**: SSH (port 22) is currently open to the world (0.0.0.0/0). For production:
   - Restrict to specific IP ranges or VPN
   - Use AWS Systems Manager Session Manager (no SSH keys needed)
   - Implement bastion host architecture

3. **HTTPS/SSL**: The application currently uses HTTP only. For production:
   - Request ACM (AWS Certificate Manager) certificate
   - Configure ALB listener for HTTPS (port 443)
   - Redirect HTTP to HTTPS automatically
   - Enable SSL/TLS encryption

4. **Database Security Enhancements**:
   - Enable encryption at rest for RDS
   - Enable encryption in transit (require SSL connections)
   - Enable automated backups and point-in-time recovery
   - Enable Multi-AZ for high availability

5. **Network Security**:
   - Use private subnets for EC2 instances and RDS
   - Implement NAT Gateway for outbound internet access
   - Use VPC endpoints for AWS services

6. **Monitoring and Logging**:
   - Enable CloudWatch logs for application
   - Enable RDS performance insights
   - Set up CloudWatch alarms for security events
   - Enable AWS CloudTrail for audit logging

## 🧹 Cleanup

To destroy all resources and avoid AWS charges:

```bash
cd tf-files
terraform destroy
```

Type `yes` when prompted to confirm resource deletion.

## 📝 Notes

- The Auto Scaling Group will automatically replace unhealthy instances
- RDS backups are disabled to reduce costs (enable for production)
- The application uses Amazon Linux 2023 AMI
- Database schema is created automatically on first run

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is available for educational and demonstration purposes.

## 👤 Author

Ismail

## 🙏 Acknowledgments

- Flask documentation
- Terraform AWS provider documentation
- AWS architecture best practices

---

**Note**: This is a demonstration project. For production use, implement proper security measures, error handling, logging, and monitoring.
