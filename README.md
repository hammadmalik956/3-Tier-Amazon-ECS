# 3-Tier-Amazon-ECS
3# MERN Stack Application Deployment on AWS

## Overview

This repository contains configurations and scripts for deploying a MERN (MongoDB, Express.js, React.js, Node.js) stack application on Amazon Web Services (AWS). The deployment can be done using either ECS (Elastic Container Service) or traditional EC2 instances, depending on your preference.

## Deployment Options

### Amazon ECS (Elastic Container Service)

For a containerized deployment using ECS, follow these steps:

1. **Prerequisites:**
   - Install the [AWS CLI](https://aws.amazon.com/cli/) and configure it with your AWS credentials.
   - Install [Docker](https://docs.docker.com/get-docker/).

2. **Build Docker Images and Push to Amazon ECR (Elastic Container Registry):**
   ```bash
   cd ecs-mern-deployment
   docker-compose build
   aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
   docker tag frontend-image:latest your-account-id.dkr.ecr.your-region.amazonaws.com/frontend-repo:latest
   docker tag backend-image:latest your-account-id.dkr.ecr.your-region.amazonaws.com/backend-repo:latest
   docker push your-account-id.dkr.ecr.your-region.amazonaws.com/frontend-repo:latest
   docker push your-account-id.dkr.ecr.your-region.amazonaws.com/backend-repo:latest

