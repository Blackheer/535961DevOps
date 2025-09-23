#!/bin/bash

# Harbor Test Script - Push and Pull Images
echo "🧪 Testing Harbor Registry..."

HARBOR_URL="harbor.local:30443"
HARBOR_USER="admin"
HARBOR_PASS="Harbor12345"
PROJECT_NAME="student535961"
IMAGE_NAME="quoter-app"
TAG="v1.0"

# Login to Harbor
echo "🔐 Logging into Harbor..."
docker login $HARBOR_URL -u $HARBOR_USER -p $HARBOR_PASS

# Create project in Harbor (via API)
echo "📁 Creating project in Harbor..."
curl -X POST "https://$HARBOR_URL/api/v2.0/projects" \
  -H "Content-Type: application/json" \
  -u "$HARBOR_USER:$HARBOR_PASS" \
  -d '{
    "project_name": "'$PROJECT_NAME'",
    "metadata": {
      "public": "false"
    }
  }' \
  --insecure

# Build your application image
echo "🔨 Building application image..."
docker build -t $HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG .

# Push image to Harbor
echo "⬆️ Pushing image to Harbor..."
docker push $HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG

# Remove local image
echo "🗑️ Removing local image..."
docker rmi $HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG

# Pull image from Harbor
echo "⬇️ Pulling image from Harbor..."
docker pull $HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG

echo "✅ Harbor test completed successfully!"
echo "🖼️ Image available at: $HARBOR_URL/$PROJECT_NAME/$IMAGE_NAME:$TAG"