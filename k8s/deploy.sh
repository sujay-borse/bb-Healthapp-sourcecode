#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f pvc.yaml
kubectl apply -f master-service-deployment.yaml
kubectl apply -f register-service-deployment.yaml
kubectl apply -f document-service-deployment.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f ingress.yaml

kubectl get all -n bbhealthapp
kubectl get ingress -n bbhealthapp
kubectl get svc -n bbhealthapp