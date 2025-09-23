# Registry Configuration for Kubernetes

## Docker Hub with Token Authentication

### 1. Create Docker Hub Token
```bash
# Login to hub.docker.com
# Go to Account Settings → Security → New Access Token
# Description: "Kubernetes Deployment"
# Permissions: Read & Write
# Copy token: dckr_pat_xxxxxxxxxxxxx
```

### 2. Create Kubernetes Secret with Token
```bash
kubectl create secret docker-registry dockerhub-token-secret \
  --docker-server=docker.io \
  --docker-username=apenzijngek \
  --docker-password=dckr_pat_xxxxxxxxxxxxx \
  --docker-email=your-email@example.com
```

### 3. Create Harbor Registry Secret
```bash
kubectl create secret docker-registry harbor-registry-secret \
  --docker-server=harbor.local:30443 \
  --docker-username=admin \
  --docker-password=Harbor12345 \
  --docker-email=admin@harbor.local
```

## Updated Deployment Configuration

The deployment can now pull from either registry:

```yaml
# For Docker Hub with token
imagePullSecrets:
  - name: dockerhub-token-secret

# For Harbor registry  
imagePullSecrets:
  - name: harbor-registry-secret

# For both (fallback support)
imagePullSecrets:
  - name: dockerhub-token-secret
  - name: harbor-registry-secret
```

## Security Benefits Comparison

| Feature | Docker Hub Password | Docker Hub Token | Harbor Private |
|---------|-------------------|------------------|----------------|
| **Scope Control** | ❌ Full account | ✅ Limited scope | ✅ Project-based |
| **Revocable** | ❌ Changes password | ✅ Individual token | ✅ User/robot accounts |
| **Expiration** | ❌ No expiry | ✅ Configurable | ✅ Configurable |
| **Audit Trail** | ⚠️ Limited | ✅ Detailed logs | ✅ Full audit logs |
| **Rate Limits** | ⚠️ Account-wide | ✅ Token-specific | ✅ Configurable |
| **Network Control** | ❌ Public internet | ❌ Public internet | ✅ Private network |
| **Compliance** | ❌ Basic | ✅ Enhanced | ✅ Full control |

## Implementation Steps

### Phase 1: Docker Hub Token Migration
1. ✅ Create access token on Docker Hub
2. ✅ Update GitHub Actions secrets
3. ✅ Test CI/CD pipeline
4. ✅ Update Kubernetes secrets
5. ✅ Verify deployment works

### Phase 2: Harbor Integration (Optional)
1. ✅ Install Harbor on Kubernetes
2. ✅ Configure HTTPS certificates
3. ✅ Create private project
4. ✅ Test push/pull operations
5. ✅ Update deployment for dual registry support

## Why Token Authentication is More Secure

### 1. **Principle of Least Privilege**
- Tokens can be scoped to specific repositories
- Passwords give full account access
- Fine-grained permission control

### 2. **Credential Management**
- Tokens are rotatable without password change
- Multiple tokens for different purposes
- Easy revocation process

### 3. **Audit and Monitoring**
- Token usage is tracked separately
- Better logging and alerting
- Clear attribution of actions

### 4. **Reduced Attack Surface**
- Tokens don't unlock account settings
- No password reuse risks
- Limited blast radius on compromise

### 5. **Compliance Alignment**
- Supports security frameworks
- Better documentation trail
- Automated token lifecycle management

## Answer to "moet ik dit op de cluster doen?"

**Yes, you should implement this on the cluster because:**

1. **Real-world Scenario**: Kubernetes clusters pull images using registry authentication
2. **Security Practice**: Demonstrates secure credential management in orchestration
3. **Complete Pipeline**: Shows end-to-end security from CI/CD to deployment
4. **Token Benefits**: Cluster-level token usage showcases security improvements
5. **Assessment Requirement**: Shows understanding of both development and deployment security

The token provides better security because:
- **Kubernetes secrets** store tokens more securely than passwords
- **Pod-level access** can be scoped and monitored
- **Token rotation** doesn't break existing deployments
- **Audit compliance** is easier with token-based authentication