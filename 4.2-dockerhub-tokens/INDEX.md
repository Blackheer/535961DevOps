# 🔐 Docker Hub Token Authentication - Opdracht 4.2

Deze map bevat alle bestanden voor het implementeren van Docker Hub token authenticatie.

## 📁 Bestandsoverzicht

| Bestand | Beschrijving |
|---------|--------------|
| `README.md` | Hoofdgids voor Docker Hub token setup |
| `kubernetes-setup.md` | Kubernetes configuratie en cluster implementatie |
| `setup-k8s-token.sh` | Geautomatiseerd setup script voor Kubernetes |
| `test-registries.sh` | Test script voor beide registry types |

## 🚀 Snelle Start

```bash
# Navigeer naar deze map
cd 4.2-dockerhub-tokens/

# 1. Maak Docker Hub access token aan
# 2. Update GitHub repository secrets
# 3. Setup Kubernetes

# Maak scripts uitvoerbaar
chmod +x setup-k8s-token.sh test-registries.sh

# Setup token in Kubernetes
./setup-k8s-token.sh dckr_pat_xxxxxxxxxxxxx

# Test beide registries
./test-registries.sh
```

## 🔒 Waarom Tokens Veiliger Zijn

| Aspect | Password | Token |
|--------|----------|-------|
| **Scope** | ❌ Volledige account | ✅ Beperkte repositories |
| **Revocatie** | ❌ Password wijzigen | ✅ Individueel intrekken |
| **Expiratie** | ❌ Geen vervaldatum | ✅ Configureerbaar |
| **Audit** | ⚠️ Beperkt | ✅ Gedetailleerde logs |
| **Attack Surface** | ❌ Account instellingen | ✅ Registry alleen |

## 📚 Documentatie

- `README.md` - Token creation en security benefits
- `kubernetes-setup.md` - Cluster implementatie en "waarom op cluster?"

## ✅ Security Improvements

- Scoped permissions
- Revocable credentials  
- Enhanced audit trail
- Reduced attack surface
- Compliance alignment