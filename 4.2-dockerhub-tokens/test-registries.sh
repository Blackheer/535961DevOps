#!/bin/bash

# Script to test both Docker Hub token and Harbor authentication

echo "🧪 Testing Registry Authentication..."

# Test 1: Docker Hub with Token
echo "📦 Testing Docker Hub with Access Token..."
if docker login -u $DOCKERHUB_LOGIN -p $DOCKER_HUB_TOKEN; then
    echo "✅ Docker Hub token authentication successful!"
    
    # Test push/pull
    docker tag $LOCAL_IMAGE $DOCKERHUB_LOGIN/student535961-app:test
    if docker push $DOCKERHUB_LOGIN/student535961-app:test; then
        echo "✅ Docker Hub push successful!"
        docker rmi $DOCKERHUB_LOGIN/student535961-app:test
        docker pull $DOCKERHUB_LOGIN/student535961-app:test
        echo "✅ Docker Hub pull successful!"
    else
        echo "❌ Docker Hub push failed!"
    fi
else
    echo "❌ Docker Hub token authentication failed!"
fi

echo ""

# Test 2: Harbor Registry
echo "🏢 Testing Harbor Registry..."
if docker login harbor.local:30443 -u admin -p Harbor12345; then
    echo "✅ Harbor authentication successful!"
    
    # Test push/pull
    docker tag $LOCAL_IMAGE harbor.local:30443/student535961/quoter-app:test
    if docker push harbor.local:30443/student535961/quoter-app:test; then
        echo "✅ Harbor push successful!"
        docker rmi harbor.local:30443/student535961/quoter-app:test
        docker pull harbor.local:30443/student535961/quoter-app:test
        echo "✅ Harbor pull successful!"
    else
        echo "❌ Harbor push failed!"
    fi
else
    echo "❌ Harbor authentication failed!"
fi

echo ""
echo "🔍 Registry Comparison:"
echo "Docker Hub: Public cloud registry with token security"
echo "Harbor: Private on-premise registry with HTTPS"
echo ""
echo "✅ Authentication tests completed!"