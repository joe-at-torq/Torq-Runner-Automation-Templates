# AWS Terraform Template
Torq Runner Host Automated Deployment

## How to use
- Create a new Docker Torq Runner integration from the Torq UI. Copy only the URL that is presented to you. See screenshot below. The entire command is not needed, only the "https://link.torq.io/**********" configuration url.

<p align="center">
  <img src="https://github.com/joe-at-torq/Torq-Runner-Automation-Templates/blob/main/misc/runner_config.png?raw=true">
</p>

- Modify the variable data inside of the variables.tf file including your Torq runner url.
- Execute the Terraform deployment by running the following commands:
  -  terraform init
  -  terraform apply


