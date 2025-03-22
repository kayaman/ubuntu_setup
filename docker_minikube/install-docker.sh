#!/bin/bash

# install-docker.sh
# Script to install Docker on Ubuntu 24.04
# Usage: bash install-docker.sh

set -e  # Exit immediately if a command exits with a non-zero status

echo "=== Installing Docker on Ubuntu 24.04 ==="
echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing prerequisites..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Setting up Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER

echo "Verifying Docker installation..."
sudo docker --version

echo "Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Verify if the docker group exists
if ! getent group docker > /dev/null 2>&1; then
  echo "Creating docker group..."
  sudo groupadd docker
  echo "Docker group created."
fi

echo "Re-adding user to the Docker group..."
sudo usermod -aG docker $USER

# Apply the group changes without requiring logout
echo "Attempting to apply group changes to current shell session..."
if command -v newgrp > /dev/null 2>&1; then
  echo "You can run 'newgrp docker' after this script completes to use Docker without sudo immediately."
fi

echo "===================================="
echo "Docker has been successfully installed!"
echo "Please log out and log back in for the group changes to take effect."
echo "After logging back in, run 'docker run hello-world' to verify the installation."
echo "===================================="