#!/bin/bash

# Setup script for Docker Hub token authentication in Kubernetes

echo "🔐 Setting up Docker Hub Token Authentication for Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Variables (update these with your actual values)
DOCKERHUB_USERNAME="apenzijngek"
DOCKERHUB_TOKEN="$1"  # Pass as first argument to script
DOCKERHUB_EMAIL="your-email@example.com"

if [ -z "$DOCKERHUB_TOKEN" ]; then
    echo "❌ Please provide Docker Hub token as first argument:"
    echo "Usage: ./setup-k8s-token.sh dckr_pat_xxxxxxxxxxxxx"
    exit 1
fi

echo "📦 Creating Docker Hub token secret..."
kubectl create secret docker-registry dockerhub-token-secret \
  --docker-server=docker.io \
  --docker-username=$DOCKERHUB_USERNAME \
  --docker-password=$DOCKERHUB_TOKEN \
  --docker-email=$DOCKERHUB_EMAIL \
  --dry-run=client -o yaml | kubectl apply -f -

if [ $? -eq 0 ]; then
    echo "✅ Docker Hub token secret created successfully!"
else
    echo "❌ Failed to create Docker Hub token secret"
    exit 1
fi

# Verify secret creation
echo "🔍 Verifying secret..."
kubectl get secret dockerhub-token-secret -o yaml | grep -E "(docker-server|docker-username)"

echo "🚀 Applying secure deployment..."
kubectl apply -f ../kubernetes/deployment-secure.yaml

echo "⏳ Waiting for deployment..."
kubectl wait --for=condition=available --timeout=300s deployment/student-devsecops-secure

echo "📊 Checking pod status..."
kubectl get pods -l app=quoterxp

echo ""
echo "✅ Setup completed! Your deployment now uses Docker Hub token authentication."
echo ""
echo "🔒 Security improvements:"
echo "  ✓ Token-based authentication instead of password"
echo "  ✓ Scoped access permissions"
echo "  ✓ Revocable credentials"
echo "  ✓ Enhanced audit trail"
echo "  ✓ Pod security context"
echo ""
echo "📱 Test your deployment:"
echo "kubectl port-forward service/nginx-service 8080:80"
echo "curl http://localhost:8080"