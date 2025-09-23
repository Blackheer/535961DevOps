# Harbor On-Premise Registry Setup

## Installation Steps

### Prerequisites
- Kubernetes cluster running
- Helm 3.x installed
- OpenSSL for certificate generation
- kubectl configured

### 1. Install Harbor on Kubernetes

```bash
# Navigate to harbor directory
cd harbor/

# Make scripts executable
chmod +x install-harbor.sh test-harbor.sh

# Run installation
./install-harbor.sh
```

### 2. Configure HTTPS with Private Certificates

The installation script automatically generates:
- **CA Certificate** (`harbor-ca.crt`) - Certificate Authority
- **Server Certificate** (`harbor-server.crt`) - Harbor server certificate
- **Private Key** (`harbor-server.key`) - Server private key

#### Certificate Configuration:
- **Subject**: `/C=NL/ST=Overijssel/L=Enschede/O=Saxion/OU=DevOps/CN=harbor.local`
- **SAN**: Includes `harbor.local`, `localhost`, and IP addresses
- **Validity**: 365 days
- **Key Size**: 4096 bits (RSA)

### 3. Post-Installation Configuration

1. **Add to hosts file** (required for local access):
   ```bash
   echo "192.168.1.100 harbor.local" >> /etc/hosts
   ```

2. **Trust the CA certificate**:
   ```bash
   # Copy CA cert to Docker
   sudo cp harbor-ca.crt /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   
   # Restart Docker
   sudo systemctl restart docker
   ```

### 4. Access Harbor

- **URL**: https://harbor.local:30443
- **Username**: admin
- **Password**: Harbor12345

### 5. Test Push/Pull

```bash
# Run test script
./test-harbor.sh
```

## Harbor Authentication Methods

Harbor supports multiple authentication protocols:

### 1. **Local Database Authentication**
- **Default method** - Users stored in Harbor's database
- **Use case**: Small teams, development environments
- **Security**: Passwords hashed with bcrypt

### 2. **LDAP/Active Directory**
- **External authentication** against LDAP server
- **Use case**: Enterprise environments with existing AD
- **Features**: Group synchronization, SSO integration

### 3. **OIDC (OpenID Connect)**
- **Modern authentication** with OAuth 2.0/OIDC providers
- **Providers**: Google, Microsoft Azure AD, Keycloak
- **Use case**: Cloud-native applications, modern SSO

### 4. **HTTP Basic Authentication**
- **Simple authentication** for API access
- **Use case**: CI/CD pipelines, automation scripts
- **Security**: Should be used with HTTPS only

### 5. **Robot Accounts**
- **Service accounts** for automated access
- **Features**: 
  - Limited scope (project-level)
  - Token-based authentication
  - Expiration dates
- **Use case**: CI/CD, automation, service-to-service

### 6. **CLI Secret/Token Authentication**
- **Docker login tokens** for CLI access
- **Generated tokens** instead of passwords
- **Use case**: Developer workstations, secure CLI access

## Security Best Practices

1. **Always use HTTPS** in production
2. **Private certificates** for internal networks
3. **Robot accounts** for automation
4. **RBAC** (Role-Based Access Control)
5. **Regular certificate rotation**
6. **Network segmentation** with firewall rules

## Troubleshooting

### Common Issues:
1. **Certificate errors**: Check SAN configuration
2. **DNS resolution**: Verify hosts file entry
3. **Firewall**: Ensure ports 30443/30444 are open
4. **Storage**: Check PVC availability in Kubernetes