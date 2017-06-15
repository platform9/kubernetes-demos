# Kubernetes Tutorial

# Access the cluster
1. Set your `OS_` env vars.
2. Pull your kubeconfig:
```
mkdir -p ~/.kube/ && qb getkubeconfig brownbag > ~/.kube/config
```

# Create your container image
1. Edit the Dockerfile
2. Build a Docker image (and tag it!)
3. Test by running the container
4. Push the image to private registry
```
docker push brownbag-registry.platform9.systems:5000/<username>/<imagename>:<version>
```

# Deploy your application on the cluster
1. Edit the Deployment and Service specs
3. Create a Deployment and Service
4. Access your application kubectl proxy with wget, or via the Platform9 UI in your browser
