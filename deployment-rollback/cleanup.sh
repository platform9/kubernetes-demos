#!/usr/bin/env bash

echo_and_run()
{
    echo "> ${@}"
    "$@"
}

echo "# Delete 'deployment-demo' namespace (Kubernetes will delete all objects in it)"
echo_and_run kubectl delete namespace deployment-demo

echo "# If you are done with the demo, switch back to your previous context:
> kubectl config set-context <your previous context>"
