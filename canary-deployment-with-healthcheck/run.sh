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
echo_and_run kubectl create namespace canary-demo
echo_and_run kubectl config set-context canary-demo-context --namespace="canary-demo" --user="$user" --cluster="$cluster"
echo_and_run kubectl config use-context canary-demo-context
pause

echo "# Create stable deployment"
echo_and_run kubectl create -f stable-nginx-deployment.yaml
pause

echo "# Create service"
echo_and_run kubectl create -f nginx-service.yaml
pause

echo "# Watch deployments and service evolve (press Ctrl-C to continue)"
echo_and_run kubectl get deployments -w

echo "# Create canary deployment"
echo_and_run kubectl create -f canary-nginx-deployment.yaml
pause

echo "# Watch the service gain endpoints (repeat command as needed)"
echo_and_run kubectl describe svc nginx

echo "# Remember to run cleanup.sh to delete all Kubernetes objects created by this demo"
