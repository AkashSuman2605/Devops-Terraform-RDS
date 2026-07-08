#!/bin/bash

set -e

echo "===================================="
echo "Updating system..."
echo "===================================="
sudo dnf update -y

echo "===================================="
echo "Installing Git..."
echo "===================================="
sudo dnf install git -y

echo "===================================="
echo "Installing Docker..."
echo "===================================="
sudo dnf install docker -y

echo "===================================="
echo "Starting Docker..."
echo "===================================="
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

echo "===================================="
echo "Installing Docker Compose..."
echo "===================================="

sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "===================================="
echo "Installing Terraform..."
echo "===================================="

sudo dnf install -y dnf-plugins-core

sudo dnf config-manager --add-repo \
https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo dnf install terraform -y

echo "===================================="
echo "Installed Versions"
echo "===================================="

git --version
docker --version
docker compose version
terraform version

echo "===================================="
echo "Setup Completed!"
echo "===================================="
echo ""
echo "IMPORTANT:"
echo "Logout and login again (or reconnect to EC2)"
echo "so that Docker can be used without sudo."
