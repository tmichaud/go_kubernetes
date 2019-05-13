#! /bin/bash

minikube start
minikube addons enable ingress
kubectl config use-context minikube
make minikube3


