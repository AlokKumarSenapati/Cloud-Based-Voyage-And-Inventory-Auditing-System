 # AWS Cloud Deployment Guide: Cloud Voyage System

This guide outlines step-by-step instructions for deploying the **Cloud Voyage & Inventory Auditing System** to AWS.

---

## Architecture Overview

```text
User / Browser
      │
      ▼ HTTP :80 / HTTPS :443
AWS EC2 Instance (or AWS App Runner / Elastic Beanstalk)
      │  └── Runs Docker container (Spring Boot + React SPA)
      │
      ├───> AWS RDS MySQL 8.4 (db.t4g.micro / Free Tier)
      └───> AWS S3 Bucket (Audit report PDFs & evidence documents)
```

---

## Step 1: Set Up AWS RDS (MySQL Database)

1. Log in to the [AWS Management Console](https://console.aws.amazon.com/).
2. Navigate to **RDS** -> Click **Create database**.
3. Choose:
   - **Database engine**: `MySQL` (version `8.0` or `8.4`).
   - **Templates**: `Free tier`.
   - **DB instance identifier**: `cloudvoyage-mysql`.
   - **Master username**: `admin`.
   - **Master password**: Enter a secure password (e.g. `CloudVoyage2026!`).
   - **DB instance class**: `db.t4g.micro` or `db.t3.micro`.
   - **Public access**: `No` (for security; only EC2 can access it) or `Yes` (if testing from local machine).
   - **Initial database name**: Under *Additional configuration*, enter `cloud_voyage_audit`.
4. Click **Create database** (takes ~5 minutes).
5. Once available, copy the **Endpoint** (e.g., `cloudvoyage-mysql.c123456789.us-east-1.rds.amazonaws.com`).

---

## Step 2: Set Up AWS S3 Bucket (Audit Report Storage)

1. In the AWS Console, search for **S3** -> Click **Create bucket**.
2. **Bucket name**: `cloudvoyage-audit-reports-<your-unique-suffix>`.
3. **AWS Region**: Select the same region as your RDS (e.g. `us-east-1`).
4. **Block Public Access**: Keep checked (enabled for security).
5. Click **Create bucket**.

---

## Step 3: Deploy to AWS EC2 (Recommended - Easiest & Free Tier)

### 3.1 Launch EC2 Instance
1. Go to **EC2** -> Click **Launch instance**.
2. **Name**: `cloud-voyage-server`.
3. **AMI**: `Ubuntu Server 24.04 LTS` (Free tier eligible).
4. **Instance type**: `t2.micro` or `t3.micro`.
5. **Key pair**: Create a new key pair (e.g., `cloudvoyage-key.pem`) and download it.
6. **Network settings (Security Group)**:
   - Allow **SSH** (Port 22) from your IP.
   - Allow **HTTP** (Port 80) from Anywhere (`0.0.0.0/0`).
   - Allow **HTTPS** (Port 443) from Anywhere (`0.0.0.0/0`).
7. Click **Launch instance**.

### 3.2 Configure RDS Security Group for EC2
1. Go to your **RDS database** -> Security -> Click on the VPC security group.
2. Add an **Inbound rule**:
   - **Type**: `MYSQL/Aurora` (Port 3306).
   - **Source**: Select the EC2 instance's Security Group ID.
   - Click **Save rules**.

### 3.3 Connect to EC2 and Run the Application
1. In your local terminal, connect via SSH:
   ```bash
   ssh -i cloudvoyage-key.pem ubuntu@<EC2-PUBLIC-IP>
   ```

2. Install Docker & Git on EC2:
   ```bash
   sudo apt update
   sudo apt install -y docker.io docker-compose git
   sudo usermod -aG docker ubuntu
   newgrp docker
   ```

3. Clone and deploy your project:
   ```bash
   git clone <your-repository-url> JAVA
   cd JAVA
   ```

4. Set your AWS environment variables:
   ```bash
   export RDS_ENDPOINT="cloudvoyage-mysql.c123456789.us-east-1.rds.amazonaws.com"
   export RDS_DB_NAME="cloud_voyage_audit"
   export RDS_USERNAME="admin"
   export RDS_PASSWORD="CloudVoyage2026!"
   export AWS_REGION="us-east-1"
   export S3_BUCKET_NAME="cloudvoyage-audit-reports-<your-suffix>"
   ```

5. Build and launch with Docker:
   ```bash
   docker build -t cloud-voyage-app .
   docker run -d --name cloud-voyage -p 80:8080 \
     -e SPRING_PROFILES_ACTIVE=prod \
     -e RDS_ENDPOINT="$RDS_ENDPOINT" \
     -e RDS_DB_NAME="$RDS_DB_NAME" \
     -e RDS_USERNAME="$RDS_USERNAME" \
     -e RDS_PASSWORD="$RDS_PASSWORD" \
     -e AWS_REGION="$AWS_REGION" \
     -e S3_BUCKET_NAME="$S3_BUCKET_NAME" \
     cloud-voyage-app
   ```

---

## Step 4: Verification

Open your web browser and navigate to:
```text
http://<EC2-PUBLIC-IP>
```
Your full-stack Cloud Voyage application is now live on AWS!

