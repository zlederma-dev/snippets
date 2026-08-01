kubectl port-forward service/snippets 8080:8080
minikube dashboard
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
minikube service snippets
minikube image load snippets:v2
