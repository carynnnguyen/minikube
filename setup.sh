#!/bin/bash

set -exu

NAMESPACE=<eks-name>
KUBERNETEST_VERSION=v1.24.0

# Install kubectl
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found, installing..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Install minikube
if ! command -v minikube &> /dev/null
then
    echo "minikube could not be found, installing..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
fi

# Start minikube
counter=1
while [[ $counter -le 2 ]] ; do
    sudo minikube start --force --driver=docker --kubernetes-version=$KUBERNETEST_VERSION && break
    ((counter++))
    # w/a forsue: HOST_JUJU_LOCK_PERMISSION
    sudo sysctl fs.protected_regular=0
    sudo chmod 777 /etc/systemd/system/
done

# Fix the kubectl context, as it's often stale.
sudo minikube update-context


# Wait for Kubernetes to be up and ready.
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until sudo kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done

# Wait for kube-dns to be ready.
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until sudo kubectl -n kube-system get pods -lk8s-app=kube-dns -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1;echo "waiting for kube-dns to be available"; sudo kubectl get pods --all-namespaces; done

# set up the environment variables needed to use the Docker daemon running
eval $(sudo minikube docker-env)


# Install Helm
if ! command -v helm &> /dev/null
then
    echo "Helm not found, installing..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

# Verify the deployment
echo "Verifying the deployment..."
kubectl get nodes

echo "Creating namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE

