#!/bin/bash

# Define ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No color

echo -e "${RED}Starting Argo Application creation...${NC}"
echo 

echo "Changing directory to argo-app-module"
cd argo-app-module

echo "Running terraform init in argo-app-module"
terraform init

echo "Running terraform apply in pargo-app-module with auto-approve"
terraform apply --auto-approve

echo 
echo -e "${GREEN}Argo Application creation completed.${NC}"

echo
echo "Wait for 30 seconds to allow ArgoCD to create the application."
sleep 30

check_deployments_ready() {
    local NAMESPACE="apps"
    local RETRY_INTERVAL=10  # seconds
    local MAX_RETRIES=60     # retry for 10 minutes

    echo 
    echo "Checking deployments in namespace $NAMESPACE..."

    # Retry loop
    for ((i=1; i<=MAX_RETRIES; i++)); do
        # Get deployments with desired and current replicas not matching, indicating they're not fully up and running
        local DEPLOYMENTS_PENDING=$(kubectl get deployments -n $NAMESPACE \
            -o jsonpath='{range .items[?(@.spec.replicas!=@.status.readyReplicas)]}{.metadata.name}{"\n"}{end}')

        # If no deployments are pending, exit loop
        if [[ -z "$DEPLOYMENTS_PENDING" ]]; then
            echo "All deployments in namespace $NAMESPACE are successfully running."
            return 0
        fi

        echo "Waiting for deployments to be ready: $DEPLOYMENTS_PENDING"
        sleep $RETRY_INTERVAL
    done

    echo "Timed out waiting for deployments to be ready."
    return 1
}

check_deployments_ready

SERVICE_NAME=$(kubectl get svc -n apps | grep -v NAME |awk '{print $1}')
kubectl port-forward -n kube-system svc/$SERVICE_NAME 9898:9898 &
echo "Port forwarding started for $SERVICE_NAME on 9898:9898"
