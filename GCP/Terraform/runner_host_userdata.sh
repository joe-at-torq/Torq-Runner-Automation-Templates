#!/bin/bash

LOG="/home/ec2-user/torq-runner.log"

#Install Docker
sudo yum update
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Download and start Runner
curl -H "Content-Type: application/x-sh" -s -L "${torq_runner_url}" | sudo sh

echo "Torq Runner deployment complete. Check /var/log/cloud-init-output.log for more details of the configuration." > $LOG