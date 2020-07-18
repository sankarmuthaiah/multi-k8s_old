# Build new images
docker build -t sankarmuthaiah/multi-docker-client:latest -t sankarmuthaiah/multi-docker-client:$SHA -f ./client/Dockerfile ./client
docker build -t sankarmuthaiah/multi-docker-server:latest -t sankarmuthaiah/multi-docker-server:$SHA -f ./server/Dockerfile ./server
docker build -t sankarmuthaiah/multi-docker-worker:latest -t sankarmuthaiah/multi-docker-worker:$SHA -f ./worker/Dockerfile ./worker

# Push the new images to docker hub
docker push sankarmuthaiah/multi-docker-client:latest
docker push sankarmuthaiah/multi-docker-server:latest
docker push sankarmuthaiah/multi-docker-worker:latest
docker push sankarmuthaiah/multi-docker-client:$SHA
docker push sankarmuthaiah/multi-docker-server:$SHA
docker push sankarmuthaiah/multi-docker-worker:$SHA

# Apply all the kubernetes config files
kubectl apply -f k8s

# Deploy the latest image
kubectl set image deployments/server-deployment server=sankarmuthaiah/multi-docker-server:$SHA
kubectl set image deployments/client-deployment client=sankarmuthaiah/multi-docker-client:$SHA
kubectl set image deployments/worker-deployment worker=sankarmuthaiah/multi-docker-worker:$SHA
