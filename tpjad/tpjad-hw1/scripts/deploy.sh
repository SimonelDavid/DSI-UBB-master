#!/bin/bash

NAMESPACE="tpjad-hw1"

# Checking namespace
echo "🔍 Checking namespace..."
if kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
  echo "✅ Namespace $NAMESPACE exists."
else
  kubectl create namespace $NAMESPACE && echo "✅ Namespace $NAMESPACE created." || { echo "❌ Failed to create namespace $NAMESPACE. Exiting."; exit 1; }
fi

# Docker context config for Minikube
echo "🔧 Configuring Docker context for Minikube..."
if eval $(minikube docker-env); then
  echo "✅ Docker context configured for Minikube."
else
  echo "❌ Failed to configure Docker context. Exiting."
  exit 1
fi

# Maven apps build
echo "🛠️ Building Maven projects..."
if mvn clean install; then
  echo "✅ Maven projects built successfully."
else
  echo "❌ Maven build failed. Exiting."
  exit 1
fi

# Docker images build
echo "🐳 Building Docker images..."
if docker build -t tomcat-custom:latest -f Docker/Dockerfile-tomcat .; then
  echo "✅ Tomcat Docker image built."
else
  echo "❌ Failed to build Tomcat Docker image. Exiting."
  exit 1
fi

if docker build -t wildfly-custom:latest -f Docker/Dockerfile-wildfly .; then
  echo "✅ WildFly Docker image built."
else
  echo "❌ Failed to build WildFly Docker image. Exiting."
  exit 1
fi

if docker build -t jetty-custom:latest -f Docker/Dockerfile-jetty .; then
  echo "✅ Jetty Docker image built."
else
  echo "❌ Failed to build Jetty Docker image. Exiting."
  exit 1
fi

# K8S apply
echo "📦 Deploying Kubernetes resources..."
kubectl delete all --all -n $NAMESPACE && echo "✅ Deleted all existing resources in namespace $NAMESPACE." || echo "⚠️ No resources to delete in namespace $NAMESPACE."

if kubectl apply -f kubernetes/tomcat.yaml; then
  echo "✅ Tomcat resources applied successfully."
else
  echo "❌ Failed to apply Tomcat resources. Exiting."
  exit 1
fi

if kubectl apply -f kubernetes/wildfly.yaml; then
  echo "✅ WildFly resources applied successfully."
else
  echo "❌ Failed to apply WildFly resources. Exiting."
  exit 1
fi

if kubectl apply -f kubernetes/jetty.yaml; then
  echo "✅ Jetty resources applied successfully."
else
  echo "❌ Failed to apply Jetty resources. Exiting."
  exit 1
fi

echo "🎉 Deployment completed successfully!"