#!/bin/bash

# setup-all.sh
# Master script to setup Docker and Minikube on Ubuntu 24.04
# Usage: bash setup-all.sh

set -e  # Exit immediately if a command exits with a non-zero status

echo "================================================================"
echo "Starting complete Docker and Minikube setup for Ubuntu 24.04"
echo "================================================================"

# Make sure all scripts are executable
chmod +x install-docker.sh
chmod +x install-minikube.sh
chmod +x minikube-utils.sh

# Step 1: Install Docker
echo "Step 1: Installing Docker..."
./install-docker.sh

# Step 2: Install Minikube and kubectl
echo "Step 2: Installing Minikube and kubectl..."
./install-minikube.sh

echo "================================================================"
echo "Setup complete! Please log out and log back in for Docker group"
echo "changes to take effect. After logging back in, you can use"
echo "minikube-utils.sh to manage your Minikube cluster."
echo ""
echo "Example commands:"
echo "  bash minikube-utils.sh start     - Start Minikube"
echo "  bash minikube-utils.sh dashboard - Open Kubernetes dashboard"
echo "  bash minikube-utils.sh help      - See all available commands"
echo "================================================================"
