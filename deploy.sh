#!/bin/bash

# Define ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No color

# Display a red message indicating that infrastructure creation is starting.
echo -e "${RED}Starting infrastructure creation...${NC}"
echo 

echo "Changing directory to platform/000-infrastructure/000-k3d"
cd platform/000-infrastructure/000-k3d

echo "Running terraform init in platform/000-infrastructure/000-k3d"
terraform init

echo "Running terraform apply in platform/000-infrastructure/000-k3d with auto-approve"
terraform apply --auto-approve

echo "Sleep for 15 seconds to let K3D Cluster settle"
sleep 15

echo "Changing directory to platform/000-infrastructure/005-nginx-ingress"
cd ../005-nginx-ingress

echo "Running terraform init in platform/000-infrastructure/005-nginx-ingress"
terraform init

echo "Running terraform apply in platform/000-infrastructure/005-nginx-ingress with auto-approve"
terraform apply --auto-approve

echo "Changing directory to platform/000-infrastructure/010-argocd"
cd ../010-argocd

echo "Running terraform init in platform/000-infrastructure/010-argocd"
terraform init

echo "Running terraform apply in platform/000-infrastructure/010-argocd with auto-approve"
terraform apply --auto-approve

# Display a green message indicating that infrastructure creation is complete.
echo 
echo -e "${GREEN}Infrastructure creation completed.${NC}"
