#!/bin/bash

# Define ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Display a red message indicating that infrastructure destruction is starting.
echo -e "${RED}Starting PLATFORM infrastructure DESTRUCTION...${NC}"
echo 

# Find and kill all kubectl port-forward processes
pkill -f "kubectl port-forward"

# Store the current working directory
ROOT_DIR="$(pwd)"

# Change directory to platform/000-infrastructure/010-argocd
echo "Changing directory to platform/000-infrastructure/010-argocd"
cd platform/000-infrastructure/010-argocd

# Run Terraform destroy with auto-approve
echo "Running terraform destroy in platform/000-infrastructure/010-argocd with auto-approve"
terraform destroy --auto-approve

# Change directory to platform/000-infrastructure/005-nginx-ingress
echo "Changing directory to platform/000-infrastructure/005-nginx-ingress"
cd ../platform/000-infrastructure/005-nginx-ingress

# Run Terraform destroy with auto-approve
echo "Running terraform destroy in platform/000-infrastructure/005-nginx-ingress with auto-approve"
terraform destroy --auto-approve

# Change directory to platform/000-infrastructure/000-k3d
echo "Changing directory to platform/000-infrastructure/000-k3d"
cd ../000-k3d

# Run Terraform destroy with auto-approve
echo "Running terraform destroy in platform/000-infrastructure/000-k3d with auto-approve"
terraform destroy --auto-approve

# Return to the original working directory
cd "$ROOT_DIR"

# Remove .terraform directories
echo "Removing .terraform directories"
find . -type d -name ".terraform" -exec rm -rf "{}" \;

# Remove terraform.tfstate* files
echo "Removing terraform.tfstate* files from the directory where the script was invoked"
find . -type f -name "terraform.tfstate*" -exec rm -f {} +

# Display a green message indicating that infrastructure destruction is complete.
echo 
echo -e "${GREEN}PLATFORM Infrastructure DESTRUCTION completed.${NC}"

