# AWS Terraform Template
Torq Runner Host Automated Deployment

## How to use
- Create a new Docker Torq Runner integration from the Torq UI. Copy the URL that is presented to you. The entire command is not needed, only the "https://link.torq.io/**********" configuration url.
- Modify the variable data inside of the variables.tf file including your Torq runner url.
- Execute the Terraform deployment by running the following commands:
  -  terraform init
  -  terraform apply


