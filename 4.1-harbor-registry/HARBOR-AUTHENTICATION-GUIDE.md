# 🔐 Harbor Authentication Methods & Protocols - Complete Guide

Harbor ondersteunt verschillende authentication methoden voor verschillende use cases. Hier is een complete uitleg van alle beschikbare methoden.

## 📋 Authentication Methods Overview

| Method | Security Level | Use Case | Implementation Complexity |
|--------|----------------|----------|-------------------------|
| Local Database | ⭐⭐⭐ | Development, Small Teams | Low |
| LDAP/Active Directory | ⭐⭐⭐⭐ | Enterprise, Existing AD | Medium |
| OIDC (OpenID Connect) | ⭐⭐⭐⭐⭐ | Modern SSO, Cloud-native | Medium-High |
| HTTP Basic Auth | ⭐⭐ | API Access, Simple Scripts | Low |
| Robot Accounts | ⭐⭐⭐⭐⭐ | CI/CD, Automation | Low-Medium |
| CLI Token Auth | ⭐⭐⭐⭐ | Developer Workstations | Low |

---

## 1. 🗄️ Local Database Authentication (Default)

### Description
Harbor's built-in user management system storing credentials in its internal database.

### How it Works
```mermaid
graph LR
    User --> Harbor[Harbor UI/API]
    Harbor --> DB[(Harbor Database)]
    DB --> Auth{Authentication}
    Auth --> Success[Access Granted]
    Auth --> Failure[Access Denied]
```

### Configuration
```yaml
# harbor.yml
auth_mode: db_auth
```

### Security Features
- **Password Hashing**: bcrypt with configurable rounds
- **Account Lockout**: After failed login attempts
- **Password Policy**: Minimum length, complexity requirements
- **Session Management**: Configurable timeout

### Use Cases
- ✅ Development environments
- ✅ Small teams (<20 users)
- ✅ Proof of concepts
- ❌ Large enterprises
- ❌ Existing identity systems

### Example Usage
```bash
# Create user via API
curl -X POST "https://harbor.local/api/v2.0/users" \
  -H "Content-Type: application/json" \
  -u "admin:Harbor12345" \
  -d '{
    "username": "developer1",
    "email": "dev1@company.com",
    "password": "SecurePass123!",
    "realname": "Developer One"
  }'

# Login via Docker CLI
docker login harbor.local -u developer1 -p SecurePass123!
```

---

## 2. 🏢 LDAP/Active Directory Authentication

### Description
Integration with existing LDAP or Active Directory infrastructure for centralized user management.

### How it Works
```mermaid
graph TB
    User --> Harbor[Harbor UI/API]
    Harbor --> LDAP[LDAP/AD Server]
    LDAP --> Verify{User Verification}
    Verify --> Groups[Group Membership]
    Groups --> Roles[Harbor Role Mapping]
    Roles --> Access[Access Granted]
```

### Configuration
```yaml
# harbor.yml
auth_mode: ldap_auth
ldap_url: ldaps://ad.company.com:636
ldap_search_dn: CN=Harbor Service,OU=ServiceAccounts,DC=company,DC=com
ldap_search_password: ServiceAccountPassword
ldap_base_dn: OU=Users,DC=company,DC=com
ldap_filter: (objectClass=person)
ldap_uid: sAMAccountName
ldap_scope: 3
ldap_group_base_dn: OU=Groups,DC=company,DC=com
ldap_group_filter: (objectClass=group)
ldap_group_gid: cn
ldap_group_scope: 3
```

### Security Features
- **Centralized Management**: Single source of truth for user accounts
- **Group-based Authorization**: LDAP groups mapped to Harbor roles
- **SSL/TLS Support**: Secure LDAP (LDAPS) connections
- **Service Account**: Dedicated account for LDAP queries

### Advanced Configuration
```yaml
# Additional LDAP settings
ldap_group_search_scope: 3
ldap_group_attribute_name: memberOf
ldap_verify_cert: true
ldap_timeout: 5
```

### Use Cases
- ✅ Enterprise environments
- ✅ Existing Active Directory
- ✅ Centralized user management
- ✅ Compliance requirements
- ❌ Small teams without AD
- ❌ Cloud-first organizations

### Example Implementation
```bash
# Test LDAP connection
ldapsearch -H ldaps://ad.company.com:636 \
  -D "CN=Harbor Service,OU=ServiceAccounts,DC=company,DC=com" \
  -w "ServiceAccountPassword" \
  -b "OU=Users,DC=company,DC=com" \
  "(sAMAccountName=john.doe)"

# User login (uses Windows credentials)
docker login harbor.local -u john.doe -p WindowsPassword
```

---

## 3. 🌐 OIDC (OpenID Connect) Authentication

### Description
Modern authentication using OAuth 2.0/OpenID Connect providers for SSO integration.

### How it Works
```mermaid
graph TB
    User --> Harbor[Harbor UI]
    Harbor --> Redirect[Redirect to OIDC Provider]
    Redirect --> OIDC[OIDC Provider<br/>Google/Azure/Keycloak]
    OIDC --> AuthCode[Authorization Code]
    AuthCode --> Harbor
    Harbor --> Token[Access Token]
    Token --> UserInfo[User Information]
    UserInfo --> Session[Harbor Session]
```

### Supported Providers
- **Google**: Google Workspace integration
- **Microsoft Azure AD**: Office 365 integration  
- **Keycloak**: Open-source identity provider
- **Okta**: Enterprise identity platform
- **Auth0**: Developer-focused identity
- **Generic OIDC**: Any OIDC-compliant provider

### Configuration Example (Azure AD)
```yaml
# harbor.yml
auth_mode: oidc_auth
oidc_name: "Azure AD"
oidc_endpoint: "https://login.microsoftonline.com/tenant-id/v2.0"
oidc_client_id: "application-client-id"
oidc_client_secret: "client-secret-value"
oidc_scope: "openid,profile,email"
oidc_verify_cert: true
oidc_auto_onboard: true
oidc_user_claim: "preferred_username"
oidc_group_claim: "groups"
```

### Security Features
- **No Password Storage**: Harbor never stores passwords
- **Multi-Factor Authentication**: Inherited from OIDC provider
- **Session Management**: Token-based sessions
- **Group Mapping**: OIDC groups to Harbor roles

### Use Cases
- ✅ Modern cloud applications
- ✅ SSO requirements
- ✅ Mobile/web applications
- ✅ Multi-factor authentication
- ❌ Legacy systems
- ❌ Air-gapped environments

### Example Configuration (Google)
```yaml
# Google OIDC configuration
oidc_name: "Google SSO"
oidc_endpoint: "https://accounts.google.com"
oidc_client_id: "123456789.apps.googleusercontent.com"
oidc_client_secret: "GOCSPX-xxxxxxxxxxxxx"
oidc_scope: "openid,profile,email"
oidc_user_claim: "email"
```

---

## 4. 🔑 HTTP Basic Authentication

### Description
Simple username/password authentication for API access and automation scripts.

### How it Works
```mermaid
graph LR
    Client --> Request[HTTP Request]
    Request --> Header[Authorization: Basic base64]
    Header --> Harbor[Harbor API]
    Harbor --> Decode[Decode Credentials]
    Decode --> Validate[Validate User/Pass]
    Validate --> Response[HTTP Response]
```

### Implementation
```bash
# Base64 encode credentials
echo -n "username:password" | base64
# Output: dXNlcm5hbWU6cGFzc3dvcmQ=

# Use in HTTP header
curl -H "Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=" \
  https://harbor.local/api/v2.0/projects

# Docker CLI (uses basic auth internally)
docker login harbor.local -u username -p password
```

### Security Considerations
- **HTTPS Required**: Credentials transmitted in clear text (base64 ≠ encryption)
- **No Expiration**: Credentials valid until changed
- **Limited Scope**: Full user permissions

### Use Cases
- ✅ Simple API scripts
- ✅ Legacy integrations
- ✅ Development/testing
- ❌ Production CI/CD
- ❌ Long-running services
- ❌ Shared credentials

---

## 5. 🤖 Robot Accounts (Recommended for CI/CD)

### Description
Service accounts designed for automated systems with scoped permissions and token-based authentication.

### How it Works
```mermaid
graph TB
    Admin --> Create[Create Robot Account]
    Create --> Scope[Define Scope/Permissions]
    Scope --> Token[Generate Access Token]
    Token --> CICD[CI/CD System]
    CICD --> Harbor[Harbor Registry]
    Harbor --> Validate[Validate Token]
    Validate --> Access[Scoped Access]
```

### Features
- **Project-Scoped**: Limited to specific projects
- **Permission Control**: Fine-grained permissions (push, pull, delete)
- **Token-Based**: No password, uses access tokens
- **Expiration**: Configurable token lifetime
- **Audit Trail**: Detailed logging of robot account actions

### Creating Robot Accounts
```bash
# Via Harbor UI
1. Go to Projects → [Your Project] → Robot Accounts
2. Click "New Robot Account"
3. Configure:
   - Name: ci-cd-robot
   - Expiration: 30 days
   - Permissions: Push and Pull

# Via API
curl -X POST "https://harbor.local/api/v2.0/projects/1/robots" \
  -H "Content-Type: application/json" \
  -u "admin:Harbor12345" \
  -d '{
    "name": "ci-cd-robot",
    "duration": 30,
    "description": "CI/CD automation robot",
    "disable": false,
    "level": "project",
    "permissions": [
      {
        "kind": "project",
        "namespace": "student535961",
        "access": [
          {"resource": "repository", "action": "push"},
          {"resource": "repository", "action": "pull"},
          {"resource": "artifact", "action": "delete"}
        ]
      }
    ]
  }'
```

### Robot Account Usage
```yaml
# GitHub Actions
- name: Login to Harbor
  uses: docker/login-action@v2
  with:
    registry: harbor.local:30443
    username: robot$ci-cd-robot
    password: ${{ secrets.HARBOR_ROBOT_TOKEN }}

# Kubernetes Secret
kubectl create secret docker-registry harbor-robot \
  --docker-server=harbor.local:30443 \
  --docker-username=robot$ci-cd-robot \
  --docker-password=robot-token-here \
  --docker-email=robot@harbor.local
```

### Security Benefits
- ✅ **Principle of Least Privilege**: Minimal required permissions
- ✅ **Token Rotation**: Regular token updates
- ✅ **Audit Logging**: Clear attribution of actions
- ✅ **Revocable**: Immediate access revocation
- ✅ **No Human Credentials**: No personal accounts in automation

---

## 6. 💻 CLI Token Authentication

### Description
Personal access tokens for individual developers, similar to GitHub personal access tokens.

### How it Works
```mermaid
graph LR
    Developer --> Generate[Generate CLI Token]
    Generate --> Token[Personal Access Token]
    Token --> Docker[Docker CLI]
    Docker --> Harbor[Harbor Registry]
    Harbor --> Validate[Token Validation]
    Validate --> Access[User-level Access]
```

### Token Generation
```bash
# Via Harbor UI
1. User Settings → User Profile
2. Generate New Token
3. Configure:
   - Name: "My Development Token"
   - Expiration: 90 days
   - Copy token immediately (won't be shown again)

# Use token with Docker
docker login harbor.local -u username -p cli_token_here
```

### Token Management
```bash
# List user tokens via API
curl -X GET "https://harbor.local/api/v2.0/users/current/cli_secret" \
  -H "Authorization: Basic $(echo -n 'user:password' | base64)"

# Revoke token
curl -X DELETE "https://harbor.local/api/v2.0/users/current/cli_secret/1" \
  -H "Authorization: Basic $(echo -n 'user:password' | base64)"
```

### Use Cases
- ✅ Developer workstations
- ✅ Personal automation scripts
- ✅ Temporary access
- ✅ Multi-device development
- ❌ Shared accounts
- ❌ Production services

---

## 🔒 Security Best Practices by Authentication Method

### Development Environment
```yaml
Recommended: Local Database + CLI Tokens
- Simple setup
- Individual developer accounts
- Token-based CLI access
- Regular token rotation
```

### Enterprise Environment
```yaml
Recommended: LDAP/AD + Robot Accounts
- Centralized user management
- Group-based permissions
- Service accounts for automation
- Compliance alignment
```

### Cloud-Native Environment
```yaml
Recommended: OIDC + Robot Accounts
- Modern SSO integration
- Multi-factor authentication
- Token-based service accounts
- Cloud identity integration
```

### High-Security Environment
```yaml
Recommended: OIDC + Robot Accounts + Network Policies
- Strong authentication
- Scoped service permissions
- Network segmentation
- Comprehensive audit logging
```

## 🎯 Authentication Method Selection Guide

### Choose Based On:

**Team Size:**
- Small (<10): Local Database
- Medium (10-100): LDAP/AD
- Large (>100): OIDC

**Infrastructure:**
- On-premise: LDAP/AD
- Cloud-first: OIDC
- Hybrid: OIDC with LDAP backup

**Automation Needs:**
- Simple CI/CD: Robot Accounts
- Complex workflows: Robot Accounts + OIDC
- Legacy systems: HTTP Basic Auth

**Compliance Requirements:**
- High compliance: OIDC + Robot Accounts
- Moderate compliance: LDAP + Robot Accounts
- Low compliance: Local Database

This comprehensive guide covers all Harbor authentication methods, helping you choose the right approach for your specific use case and security requirements.