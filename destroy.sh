#!/bin/bash

# Store the current working directory
ROOT_DIR="$(pwd)"

# Change directory to platform/000-infrastructure/010-argocd
echo "Changing directory to platform/000-infrastructure/010-argocd"
cd platform/000-infrastructure/010-argocd

# Run Terraform destroy with auto-approve
echo "Running terraform destroy in platform/000-infrastructure/010-argocd with auto-approve"
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

# Optionally, you can add additional commands or actions as needed

echo "Destroy script completed."
