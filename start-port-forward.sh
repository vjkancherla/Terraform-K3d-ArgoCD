#!/bin/bash

# 1. Identify the Kubernetes service in kube-system namespace containing "nginx-controller" in its name but not "nginx-controller-admission"
SERVICE_NAME=$(kubectl get svc -n kube-system | grep nginx-controller | grep -v nginx-controller-admission | awk '{print $1}')

# Check if the service name was identified
if [ -z "$SERVICE_NAME" ]; then
  echo "No service with name containing 'nginx-controller' (excluding those with 'nginx-controller-admission') found in kube-system namespace."
  exit 1
fi

echo "Identified service: $SERVICE_NAME"

# 2. Create a port forward in the background
kubectl port-forward -n kube-system svc/$SERVICE_NAME 8443:443 &
echo "Port forwarding started for $SERVICE_NAME on 8443:443"

# Optionally, to keep the terminal open after the script runs (useful in some scenarios):
# read -p "Press any key to terminate the port-forward and exit..."

# If you uncomment the above line, you can stop the port-forward process when a key is pressed:
# kill $!
