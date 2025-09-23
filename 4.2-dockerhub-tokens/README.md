# Docker Hub Token Authentication Setup

## Why Use Tokens Instead of Passwords?

### Security Benefits:
1. **Scoped Access**: Tokens can be limited to specific repositories
2. **Time-Limited**: Tokens can have expiration dates
3. **Revocable**: Easy to revoke without changing main password
4. **Audit Trail**: Better logging and monitoring
5. **No Password Exposure**: Main account password never shared
6. **Rate Limiting**: Tokens have different rate limits

### Risk Reduction:
- **Credential Stuffing**: Tokens are unique, not reused passwords
- **Brute Force**: Tokens are long random strings
- **Account Compromise**: Revoking token doesn't affect main account

## Creating Docker Hub Access Token

### Step 1: Login to Docker Hub
1. Go to https://hub.docker.com/
2. Login with your credentials
3. Click on your username (top right)
4. Select "Account Settings"

### Step 2: Create Access Token
1. Go to "Security" tab
2. Click "New Access Token"
3. Configure token:
   - **Description**: "GitHub Actions CI/CD"
   - **Access permissions**: "Read & Write" (or "Read, Write, Delete")
   - **Repository access**: Select specific repositories or "All repositories"

### Step 3: Copy Token
- **⚠️ Important**: Copy the token immediately - it won't be shown again!
- Format: `dckr_pat_xxxxxxxxxxxxxxxxx`

## Updating GitHub Actions Secrets

### Step 4: Update GitHub Secrets
1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Update existing secrets:
   - `DOCKERHUB_LOGIN`: Your Docker Hub username
   - `DOCKER_HUB_PASSWORD`: **Replace with your new token** (not password!)

### Secret Configuration:
- **DOCKERHUB_LOGIN**: `apenzijngek` (your username)
- **DOCKER_HUB_PASSWORD**: `dckr_pat_xxxxxxxxxxxxxxxxx` (your token)

## Updated Workflow

The workflow remains the same - Docker login action automatically detects tokens:

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v2
  with:
    username: ${{ secrets.DOCKERHUB_LOGIN }}
    password: ${{ secrets.DOCKER_HUB_PASSWORD }}  # Now contains token!
```

## Verification Steps

### 1. Test Local Docker Login
```bash
# Test token authentication locally
docker login -u apenzijngek -p dckr_pat_xxxxxxxxxxxxxxxxx
```

### 2. Verify GitHub Actions
- Push code changes
- Check Actions tab for successful builds
- Verify Docker Hub push operations work

### 3. Monitor Usage
- Docker Hub → Account Settings → Security
- View token usage statistics
- Monitor for unusual activity

## Token Management Best Practices

### 1. **Regular Rotation**
- Rotate tokens every 90 days
- Use calendar reminders
- Document rotation in security log

### 2. **Scope Limitation**
- Use minimum required permissions
- Limit to specific repositories when possible
- Separate tokens for different purposes

### 3. **Monitoring**
- Regular security audits
- Monitor token usage patterns
- Alert on unusual activities

### 4. **Emergency Procedures**
- Keep revocation process documented
- Have backup authentication methods
- Test disaster recovery procedures

## Troubleshooting

### Common Issues:
1. **401 Unauthorized**: Check token format and permissions
2. **Rate Limiting**: Token may have different limits than password
3. **Scope Issues**: Verify repository access permissions
4. **Expiration**: Check token expiration date

### Debug Commands:
```bash
# Test token validity
curl -u "username:token" https://hub.docker.com/v2/repositories/username/

# Check Docker login
docker system info | grep -i registry
```

## Security Compliance

### Benefits for DevOps Security:
- **✅ Authentication**: Strong token-based auth
- **✅ Authorization**: Scoped permissions
- **✅ Audit**: Better logging and monitoring  
- **✅ Non-repudiation**: Clear token ownership
- **✅ Confidentiality**: Tokens vs passwords

### Compliance Standards:
- **NIST**: Aligns with token-based authentication guidelines
- **OWASP**: Reduces password-related vulnerabilities
- **SOC 2**: Improves access control documentation