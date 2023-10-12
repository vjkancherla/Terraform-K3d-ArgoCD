#!/bin/bash

echo "Changing directory to platform/000-infrastructure/000-k3d"
cd platform/000-infrastructure/000-k3d

echo "Running terraform init in platform/000-infrastructure/000-k3d"
terraform init

echo "Running terraform apply in platform/000-infrastructure/000-k3d with auto-approve"
terraform apply --auto-approve

echo "Changing directory to platform/000-infrastructure/010-argocd"
cd ../010-argocd

echo "Running terraform init in platform/000-infrastructure/010-argocd"
terraform init

echo "Running terraform apply in platform/000-infrastructure/010-argocd with auto-approve"
terraform apply --auto-approve

# Optionally, you can add additional commands or actions as needed

echo "Script completed."
