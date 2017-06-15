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
```
docker build -t <your_image_tag> .
```
3. Test by running the container
```
docker run -d -p hostport:containerport <your_image_tag>
```
Note that to push to the brownbag registry, tag your image as:
brownbag-registry.platform9.systems:5000/<username>/<imagename>:<version>
4. Push the image to private registry
```
docker push brownbag-registry.platform9.systems:5000/<username>/<imagename>:<version>
```

# Deploy your application on the cluster
1. Edit the Deployment and Service specs
3. Create a Deployment and Service
```
kubectl create -f deployment.yaml
kubectl create -f service.yaml
```
4. Access your application kubectl proxy with wget, or via the Platform9 UI in your browser
```
kubectl proxy &
curl http://127.0.0.1:8001/api/v1/proxy/namespaces/<yournamespace>/services/<your-svc-name>/
```
