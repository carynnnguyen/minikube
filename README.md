# Setup Local Kubernetes Cluster with Flink and Pulsar using Minikube
## Introduction

This script installs and deploys Flink and Pulsar with Helm in a Kubernetes cluster using minikube.

## Prerequisites
- Docker
- Curl


## Usage
### Setup
1. Open the `setup.sh` file and modify the variables at the beginning of the script to specify your namespace (default name is `<eks-name>`)

2. Open a terminal and navigate to the directory containing the `setup.sh` file.
Run the following command to execute the script:

    ```bash
    sudo bash setup.sh
    ```

3. Verify that the pods for Flink and Pulsar are running in the `<eks-name>` namespace:

    ```bash
    sudo kubectl get pods --namespace `<eks-name>`
    ```

4. Waiting for Flink and Pulsar is ready:
Run the following command to check:
    ``` bash
    sudo kubectl get pods -n <your-namespace>

    ex: sudo kubectl get pods -n <eks-name>

    ```

5. After everything is ready, the Flink UI can be access via: `<minikube-ip>:32328`

> Note: get minikube IP by command:
> ``` bash
> minikube ip
> ```

## Remove minikube
Open a terminal and navigate to the directory containing the `remove_minikube.sh` file.
Run the following command to execute the script:

```bash
sudo bash remove_minikube.sh
```
