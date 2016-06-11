#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <user> <cluster>"
    exit 1
fi
user=$1
cluster=$2

# Continue running if SIGINT (Ctrl-C) is sent
trap : INT

pause()
{
    read  -n 1 -p "# Press any key to continue..."
    echo -e "\n"
}

echo_and_run()
{
    echo "> ${@}"
    "$@"
}

echo "# Create and use demo context"
echo_and_run kubectl create namespace deployment-demo
echo_and_run kubectl config set-context deployment-demo-context --namespace="deployment-demo" --user="$user" --cluster="$cluster"
echo_and_run kubectl config use-context deployment-demo-context
pause

echo "# Create deployment"
echo_and_run kubectl create -f nginx-deployment.yaml --record
pause

echo "# Examine Replica Sets (press Ctrl-C to continue)"
echo_and_run kubectl get rs -w
echo "# Examine Deployments (press Ctrl-C to continue)"
echo_and_run kubectl get deployments -w
echo "# Examine Pods"
echo_and_run kubectl get pods --show-labels -w

echo "# Verify deployment controller is aware of most recent deployment"
echo "# (observedGeneration >= generation)"
echo_and_run kubectl get deployment/nginx-deployment -o yaml | grep [Gg]eneration
pause

echo "# We could update deployment in place by running"
echo "# kubectl edit deployment/nginx-deployment"
echo "# Instead, we will apply updates from a file"
echo_and_run kubectl apply -f new-nginx-deployment.yaml
pause

echo "# Examine Replica Sets (press Ctrl-C to continue)"
echo_and_run kubectl get rs -w
echo "# Examine Deployments (press Ctrl-C to continue)"
echo_and_run kubectl get deployments -w
echo "# Examine Pods"
echo_and_run kubectl get pods --show-labels -w

echo "# Create bad deployment (there is typo in image name,
# so the image pull will fail)"
echo_and_run kubectl apply -f bad-nginx-deployment.yaml
pause

echo "# Examine Replica Sets (press Ctrl-C to continue)"
echo_and_run kubectl get rs -w
echo "# Examine Deployments (press Ctrl-C to continue)"
echo_and_run kubectl get deployments -w
echo "# Examine Pods"
echo_and_run kubectl get pods --show-labels -w

echo "# Examine rollback history"
echo "# Note that the 'CHANGE-CAUSE' column is non-empty because of"
echo "# the --record argument to the initial create deployment command"
echo_and_run kubectl rollout history deployment/nginx-deployment
pause
echo "# Examine rollback history for the bad revision of the deployment"
echo_and_run kubectl rollout history deployment/nginx-deployment --revision=3
pause

echo "# Roll back bad deployment"
echo_and_run kubectl rollout undo deployment/nginx-deployment
pause

echo "# Examine Replica Sets (press Ctrl-C to continue)"
echo_and_run kubectl get rs -w
echo "# Examine Deployments (press Ctrl-C to continue)"
echo_and_run kubectl get deployments -w
echo "# Examine Pods"
echo_and_run kubectl get pods --show-labels -w

echo "# Remember to run cleanup.sh to delete all Kubernetes objects created by this demo"
