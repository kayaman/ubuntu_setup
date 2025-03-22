#!/bin/bash

# install-kubectl.sh
# Script to install kubectl on Ubuntu 24.04
# Usage: bash install-kubectl.sh

set -e  # Exit immediately if a command exits with a non-zero status

echo "=== Installing kubectl on Ubuntu 24.04 ==="

# Check if kubectl is already installed
if command -v kubectl &> /dev/null; then
  echo "kubectl is already installed. Current version:"
  kubectl version --client
  
  read -p "Do you want to reinstall kubectl? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation canceled."
    exit 0
  fi
fi

echo "Installing prerequisites..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl

echo "Setting up kubectl installation..."

# Decide which installation method to use
installation_method=""
while [[ ! "$installation_method" =~ ^[1-3]$ ]]; do
  echo "Please select an installation method:"
  echo "1) Using apt package manager (Recommended)"
  echo "2) Manual download of latest stable release"
  echo "3) Using curl with automatic version detection"
  read -p "Enter your choice (1-3): " installation_method
done

case $installation_method in
  1)
    echo "Installing kubectl using apt package manager..."
    
    # Create the keyrings directory if it doesn't exist
    sudo mkdir -p /etc/apt/keyrings
    
    # Download the Google Cloud public signing key
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    
    # Add the Kubernetes apt repository
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    # Update apt package index with the new repository and install kubectl
    sudo apt update
    sudo apt install -y kubectl
    ;;
    
  2)
    echo "Installing kubectl via manual download..."
    
    # Download the latest stable release version
    curl -LO "https://dl.k8s.io/release/stable.txt"
    KUBECTL_VERSION=$(cat stable.txt)
    echo "Latest stable version: $KUBECTL_VERSION"
    
    # Download kubectl binary
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    
    # Validate the binary (optional but recommended)
    curl -LO "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
    echo "Validating kubectl binary..."
    if echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check; then
      echo "Validation successful!"
    else
      echo "Validation failed! The kubectl binary may be corrupted."
      exit 1
    fi
    
    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    
    # Clean up the downloaded files
    rm kubectl kubectl.sha256 stable.txt
    ;;
    
  3)
    echo "Installing kubectl using curl with automatic version detection..."
    
    # One-liner to download and install the latest version
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    ;;
esac

# Verify the installation
echo "Verifying kubectl installation..."
kubectl_version=$(kubectl version --client 2>/dev/null)
if [ $? -eq 0 ]; then
  echo "kubectl installed successfully!"
  echo "$kubectl_version"
else
  echo "kubectl installation verification failed."
  exit 1
fi

# Set up kubectl autocomplete
echo "Setting up kubectl autocomplete..."

# Detect shell
current_shell=$(basename "$SHELL")
if [[ "$current_shell" == "zsh" ]]; then
  # Setup for zsh
  echo 'source <(kubectl completion zsh)' >>~/.zshrc
  echo 'alias k=kubectl' >>~/.zshrc
  echo 'compdef __start_kubectl k' >>~/.zshrc
  echo "Added kubectl completion to ~/.zshrc"
  echo "Run 'source ~/.zshrc' to apply changes to current shell."
else
  # Default to bash
  echo 'source <(kubectl completion bash)' >>~/.bashrc
  echo 'alias k=kubectl' >>~/.bashrc
  echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
  echo "Added kubectl completion to ~/.bashrc"
  echo "Run 'source ~/.bashrc' to apply changes to current shell."
fi

# Create kubectl config directory if it doesn't exist
mkdir -p ~/.kube

echo "===================================="
echo "kubectl has been successfully installed!"
echo "You can now use kubectl to interact with Kubernetes clusters."
echo ""
echo "Basic commands to get started:"
echo "  kubectl version --client    # Check client version"
echo "  kubectl config view         # View configuration"
echo "  kubectl get nodes           # List nodes in a cluster"
echo ""
echo "To configure kubectl for a specific cluster, you'll need to set up"
echo "a kubeconfig file in ~/.kube/config."
echo "===================================="
