#!/bin/bash

# Script om een self-signed TLS certificaat te genereren voor Kubernetes

echo "Genereren van self-signed TLS certificaat..."

# Genereer een private key
openssl genrsa -out tls.key 2048

# Genereer een certificate signing request (CSR)
openssl req -new -key tls.key -out tls.csr -subj "/CN=quoter.local/O=SolidApps"

# Genereer een self-signed certificaat (geldig voor 365 dagen)
openssl x509 -req -days 365 -in tls.csr -signkey tls.key -out tls.crt

echo "Certificaat gegenereerd: tls.crt en tls.key"

# Creëer Kubernetes secret met het certificaat
echo "Aanmaken van Kubernetes TLS secret..."
kubectl create secret tls quoter-tls \
  --cert=tls.crt \
  --key=tls.key \
  --namespace=default \
  --dry-run=client -o yaml > tls-secret-generated.yaml

echo "TLS secret YAML gegenereerd: tls-secret-generated.yaml"
echo ""
echo "Je kunt nu de secret toepassen met:"
echo "kubectl apply -f tls-secret-generated.yaml"
echo ""
echo "Of direct aanmaken met:"
echo "kubectl create secret tls quoter-tls --cert=tls.crt --key=tls.key --namespace=default"

# Opruimen CSR
rm tls.csr

echo ""
echo "✓ Certificaat bestanden aangemaakt:"
echo "  - tls.crt (certificaat)"
echo "  - tls.key (private key)"
echo "  - tls-secret-generated.yaml (Kubernetes secret)"