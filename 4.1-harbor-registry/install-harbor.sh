#!/bin/bash

# Harbor Installation Script for Kubernetes
echo "🚢 Installing Harbor on Kubernetes..."

# Create harbor namespace
kubectl create namespace harbor

# Add Harbor Helm repository
echo "Adding Harbor Helm repository..."
helm repo add harbor https://helm.goharbor.io
helm repo update

# Generate TLS certificates for Harbor
echo "🔐 Generating TLS certificates..."

# Create private key
openssl genrsa -out harbor-ca.key 4096

# Create CA certificate
openssl req -new -x509 -days 365 -key harbor-ca.key -out harbor-ca.crt -subj "/C=NL/ST=Overijssel/L=Enschede/O=Saxion/OU=DevOps/CN=Harbor-CA"

# Create server private key
openssl genrsa -out harbor-server.key 4096

# Create certificate signing request
openssl req -new -key harbor-server.key -out harbor-server.csr -subj "/C=NL/ST=Overijssel/L=Enschede/O=Saxion/OU=DevOps/CN=harbor.local"

# Create server certificate
openssl x509 -req -days 365 -in harbor-server.csr -CA harbor-ca.crt -CAkey harbor-ca.key -CAcreateserial -out harbor-server.crt -extensions v3_req -extfile <(echo "
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = harbor.local
DNS.2 = localhost
IP.1 = 127.0.0.1
IP.2 = 192.168.1.100
")

# Create Kubernetes TLS secrets
echo "Creating Kubernetes TLS secrets..."
kubectl create secret tls harbor-tls \
  --cert=harbor-server.crt \
  --key=harbor-server.key \
  --namespace=harbor

kubectl create secret tls notary-tls \
  --cert=harbor-server.crt \
  --key=harbor-server.key \
  --namespace=harbor

# Install Harbor using Helm
echo "🚀 Installing Harbor with Helm..."
helm install harbor harbor/harbor \
  --namespace harbor \
  --values harbor-values.yaml \
  --wait --timeout 10m

# Wait for all pods to be ready
echo "⏳ Waiting for Harbor to be ready..."
kubectl wait --for=condition=ready pod --all -n harbor --timeout=600s

# Get Harbor URL and credentials
echo "✅ Harbor installation completed!"
echo ""
echo "🌐 Harbor URL: https://harbor.local:30443"
echo "👤 Username: admin"
echo "🔑 Password: Harbor12345"
echo ""
echo "📝 Don't forget to:"
echo "1. Add 'harbor.local' to your /etc/hosts file pointing to your cluster IP"
echo "2. Trust the harbor-ca.crt certificate in your system"
echo ""
echo "🔍 Check Harbor status:"
echo "kubectl get pods -n harbor"
echo "kubectl get svc -n harbor"