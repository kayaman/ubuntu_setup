#!/bin/bash

# minikube-utils.sh
# Utility script for managing Minikube
# Usage: bash minikube-utils.sh [command]

set -e  # Exit immediately if a command exits with a non-zero status

# Show usage information
show_usage() {
  echo "Minikube Utility Script"
  echo "Usage: bash minikube-utils.sh [command]"
  echo ""
  echo "Available commands:"
  echo "  start     - Start Minikube cluster"
  echo "  stop      - Stop Minikube cluster"
  echo "  status    - Check Minikube status"
  echo "  delete    - Delete Minikube cluster"
  echo "  dashboard - Open Kubernetes dashboard"
  echo "  addons    - List and enable/disable addons"
  echo "  help      - Show this help information"
  echo ""
  echo "Examples:"
  echo "  bash minikube-utils.sh start"
  echo "  bash minikube-utils.sh addons enable ingress"
}

# Start Minikube
start_minikube() {
  echo "Starting Minikube with Docker driver..."
  minikube start --driver=docker
  echo "Minikube started successfully."
  minikube status
}

# Stop Minikube
stop_minikube() {
  echo "Stopping Minikube..."
  minikube stop
  echo "Minikube stopped."
}

# Check Minikube status
check_status() {
  echo "Checking Minikube status..."
  minikube status
}

# Delete Minikube cluster
delete_minikube() {
  echo "Deleting Minikube cluster..."
  minikube delete
  echo "Minikube cluster deleted."
}

# Open Kubernetes dashboard
open_dashboard() {
  echo "Opening Kubernetes dashboard in your default browser..."
  minikube dashboard
}

# Manage addons
manage_addons() {
  if [ "$#" -eq 0 ]; then
    echo "Listing available addons..."
    minikube addons list
    echo ""
    echo "To enable an addon: bash minikube-utils.sh addons enable ADDON_NAME"
    echo "To disable an addon: bash minikube-utils.sh addons disable ADDON_NAME"
    return
  fi
  
  action=$1
  addon=$2
  
  if [ "$action" = "enable" ]; then
    echo "Enabling $addon addon..."
    minikube addons enable $addon
    echo "$addon addon enabled."
  elif [ "$action" = "disable" ]; then
    echo "Disabling $addon addon..."
    minikube addons disable $addon
    echo "$addon addon disabled."
  else
    echo "Unknown addon action: $action"
    echo "Use 'enable' or 'disable'"
  fi
}

# Main function
main() {
  if [ "$#" -eq 0 ]; then
    show_usage
    exit 0
  fi

  command=$1
  shift  # Remove the first argument (the command) from the arguments list

  case $command in
    start)
      start_minikube
      ;;
    stop)
      stop_minikube
      ;;
    status)
      check_status
      ;;
    delete)
      delete_minikube
      ;;
    dashboard)
      open_dashboard
      ;;
    addons)
      manage_addons "$@"
      ;;
    help)
      show_usage
      ;;
    *)
      echo "Unknown command: $command"
      show_usage
      exit 1
      ;;
  esac
}

# Run the main function with all arguments
main "$@"
