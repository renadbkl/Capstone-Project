#!/bin/bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
kubectl create namespace monitor
helm install prometheus-operator stable/prometheus-operator --namespace monitor --set grafana.service.type=LoadBalancer
kubectl apply -f ingress.yaml -n monitor
