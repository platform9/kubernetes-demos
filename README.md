# Kubernetes Demos

This is a collection of demos of Kubernetes' capabilities.

## Usage
Run each demo with `run.sh`. Once you're done, run `cleanup.sh` to remove all
Kubernetes objects created by the demo.

To run a demo, you must:
- have access to a Kubernetes cluster
- are authorized to create a namespace in that cluster
- use a `kubeconfig` that has a 'cluster' record for that cluster
- have `kubectl` in your path
