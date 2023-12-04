#!/bin/bash

# Stop and delete Minikube virtual machine
minikube stop
minikube delete

# Remove Minikube binary
sudo rm -rf /usr/local/bin/minikube

# Remove Minikube configuration directory
rm -rf ~/.minikube

# Remove kubectl configuration
rm -rf ~/.kube

echo "Minikube has been successfully removed from your system."
