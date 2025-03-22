#!/bin/bash

# install-minikube.sh
# Script to install Minikube and kubectl on Ubuntu 24.04
# Usage: bash install-minikube.sh

set -e  # Exit immediately if a command exits with a non-zero status

echo "=== Installing Minikube on Ubuntu 24.04 ==="
echo "Installing prerequisites..."
sudo apt install -y curl wget apt-transport-https

echo "Downloading Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

echo "Installing Minikube..."
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "Downloading kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "Installing kubectl..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "Verifying installations..."
echo "Minikube version:"
minikube version
echo "Kubectl version:"
kubectl version --client

echo "Setting Docker as the default driver for Minikube..."
minikube config set driver docker

echo "===================================="
echo "Minikube and kubectl have been successfully installed!"
echo "To start Minikube, run: minikube start"
echo "===================================="
