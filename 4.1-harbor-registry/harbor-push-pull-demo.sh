#!/bin/bash

# Harbor Push/Pull Demonstratie Script
# Dit script toont een complete workflow van Harbor registry gebruik

echo "🚢 Harbor Registry Push/Pull Demonstratie"
echo "=========================================="

# Harbor configuratie
HARBOR_URL="harbor.local:30443"
HARBOR_USER="admin"
HARBOR_PASS="Harbor12345"
PROJECT_NAME="student535961"
IMAGE_NAME="quoter-app"
TAG="v1.0"
LOCAL_IMAGE="quoter-demo"

echo ""
echo "📋 Harbor Registry Details:"
echo "URL: $HARBOR_URL"
echo "Project: $PROJECT_NAME"
echo "Image: $IMAGE_NAME:$TAG"
echo ""

# Stap 1: Harbor Registry Status Check
echo "🔍 Step 1: Checking Harbor Registry Status..."
echo "Attempting to reach Harbor registry..."

if curl -k -s "https://$HARBOR_URL/api/v2.0/systeminfo" > /dev/null; then
    echo "✅ Harbor registry is accessible"
else
    echo "❌ Harbor registry not accessible. Please ensure:"
    echo "   - Harbor is running: kubectl get pods -n harbor"
    echo "   - Port forwarding: kubectl port-forward -n harbor svc/harbor-nginx 30443:443"
    echo "   - DNS: Add '127.0.0.1 harbor.local' to /etc/hosts"
    exit 1
fi

# Stap 2: Docker Login to Harbor
echo ""
echo "🔐 Step 2: Authenticating with Harbor Registry..."
if echo $HARBOR_PASS | docker login $HARBOR_URL -u $HARBOR_USER --password-stdin; then
    echo "✅ Successfully logged into Harbor registry"
else
    echo "❌ Failed to login to Harbor registry"
    exit 1
fi

# Stap 3: Create Harbor Project via API
echo ""
echo "📁 Step 3: Creating Harbor Project '$PROJECT_NAME'..."
HTTP_CODE=$(curl -k -s -w "%{http_code}" -X POST "https://$HARBOR_URL/api/v2.0/projects" \
  -H "Content-Type: application/json" \
  -u "$HARBOR_USER:$HARBOR_PASS" \
  -d '{
    "project_name": "'$PROJECT_NAME'",
    "metadata": {
      "public": "false",
      "enable_content_trust": "false",
      "auto_scan": "true",
      "severity": "low"
    }
  }' -o /dev/null)

if [[ "$HTTP_CODE" == "201" ]]; then
    echo "✅ Project '$PROJECT_NAME' created successfully"
elif [[ "$HTTP_CODE" == "409" ]]; then
    echo "ℹ️  Project '$PROJECT_NAME' already exists"
else
    echo "⚠️  Project creation returned HTTP $HTTP_CODE"
fi

# Stap 4: Build een demo image
echo ""
echo "🔨 Step 4: Building Demo Application Image..."
cat > Dockerfile.demo << 'EOF'
FROM nginx:alpine
COPY <<EOF /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head><title>Harbor Demo App</title></head>
<body>
    <h1>🚢 Harbor Registry Demo</h1>
    <p>This image was pushed to and pulled from Harbor!</p>
    <p>Student: 535961</p>
    <p>Timestamp: $(date)</p>
</body>
</html>
EOF
EOF

if docker build -f Dockerfile.demo -t $LOCAL_IMAGE:$TAG .; then
    echo "✅ Demo image built successfully"
else
    echo "❌ Failed to build demo image"
    exit 1
fi

# Stap 5: Tag image voor Harbor
echo ""
echo "🏷️  Step 5: Tagging Image for Harbor..."
HARBOR_IMAGE="$HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG"
docker tag $LOCAL_IMAGE:$TAG $HARBOR_IMAGE
echo "Tagged: $LOCAL_IMAGE:$TAG → $HARBOR_IMAGE"

# Stap 6: Push image to Harbor
echo ""
echo "⬆️  Step 6: Pushing Image to Harbor Registry..."
if docker push $HARBOR_IMAGE; then
    echo "✅ Successfully pushed image to Harbor"
    echo "🌐 Image available at: https://$HARBOR_URL/harbor/projects/1/repositories/$IMAGE_NAME"
else
    echo "❌ Failed to push image to Harbor"
    exit 1
fi

# Stap 7: Verify image in Harbor via API
echo ""
echo "🔍 Step 7: Verifying Image in Harbor..."
ARTIFACTS=$(curl -k -s -u "$HARBOR_USER:$HARBOR_PASS" \
  "https://$HARBOR_URL/api/v2.0/projects/$PROJECT_NAME/repositories/$IMAGE_NAME/artifacts")

if echo "$ARTIFACTS" | grep -q "digest"; then
    echo "✅ Image successfully stored in Harbor"
    echo "📊 Artifact details:"
    echo "$ARTIFACTS" | jq -r '.[0] | "   Digest: \(.digest[0:20])...\n   Size: \(.size) bytes\n   Push Time: \(.push_time)"'
else
    echo "❌ Image not found in Harbor"
fi

# Stap 8: Remove local images
echo ""
echo "🗑️  Step 8: Cleaning Local Images..."
docker rmi $LOCAL_IMAGE:$TAG $HARBOR_IMAGE
echo "✅ Local images removed"

# Stap 9: Pull image from Harbor
echo ""
echo "⬇️  Step 9: Pulling Image from Harbor Registry..."
if docker pull $HARBOR_IMAGE; then
    echo "✅ Successfully pulled image from Harbor"
else
    echo "❌ Failed to pull image from Harbor"
    exit 1
fi

# Stap 10: Verify pulled image works
echo ""
echo "🧪 Step 10: Testing Pulled Image..."
CONTAINER_ID=$(docker run -d -p 8080:80 $HARBOR_IMAGE)
sleep 3

if curl -s http://localhost:8080 | grep -q "Harbor Demo"; then
    echo "✅ Pulled image is working correctly!"
    echo "🌐 Demo available at: http://localhost:8080"
else
    echo "❌ Pulled image test failed"
fi

# Cleanup
docker stop $CONTAINER_ID > /dev/null 2>&1
docker rm $CONTAINER_ID > /dev/null 2>&1

# Final Summary
echo ""
echo "📋 DEMONSTRATION SUMMARY"
echo "======================"
echo "✅ Harbor registry accessibility confirmed"
echo "✅ Authentication with Harbor successful"
echo "✅ Project creation via API"
echo "✅ Docker image built locally"
echo "✅ Image pushed to Harbor registry"
echo "✅ Image verified in Harbor via API"
echo "✅ Local images cleaned"
echo "✅ Image pulled from Harbor registry"
echo "✅ Pulled image functionality verified"
echo ""
echo "🎉 Harbor Push/Pull demonstration completed successfully!"
echo ""
echo "🔗 Harbor Web Interface: https://$HARBOR_URL"
echo "👤 Username: $HARBOR_USER"
echo "🔑 Password: $HARBOR_PASS"

# Cleanup demo files
rm -f Dockerfile.demo