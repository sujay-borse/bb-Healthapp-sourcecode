#!/bin/bash

REGISTRY="874632206513.dkr.ecr.us-west-2.amazonaws.com"

docker build -t bbhealthapp-master-service:latest ../bbhealthapp-backend/bbhealthapp-api-master
docker tag bbhealthapp-master-service:latest $REGISTRY/bbhealthapp-master-service:latest

docker build -t bbhealthapp-register-service:latest ../bbhealthapp-backend/bbhealthapp-api-register
docker tag bbhealthapp-register-service:latest $REGISTRY/bbhealthapp-register-service:latest

docker build -t bbhealthapp-document-service:latest ../bbhealthapp-backend/bbhealthapp-api-document
docker tag bbhealthapp-document-service:latest $REGISTRY/bbhealthapp-document-service:latest

docker build -t bbhealthapp-frontend:latest ../bbhealthapp-frontend
docker tag bbhealthapp-frontend:latest $REGISTRY/bbhealthapp-frontend:latest

docker push $REGISTRY/bbhealthapp-master-service:latest
docker push $REGISTRY/bbhealthapp-register-service:latest
docker push $REGISTRY/bbhealthapp-document-service:latest
docker push $REGISTRY/bbhealthapp-frontend:latest