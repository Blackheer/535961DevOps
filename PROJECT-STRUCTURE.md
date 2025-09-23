# 📁 Project Mapstructuur - DevOps Security Opdrachten 4.1 & 4.2

## 🗂️ Georganiseerde Mapstructuur

```
535961DevOps/
├── 4.1-harbor-registry/           # 🚢 Harbor On-Premise Registry
│   ├── INDEX.md                   # Overzicht van Harbor implementatie
│   ├── README.md                  # Gedetailleerde Harbor handleiding
│   ├── harbor-values.yaml         # Helm configuratie
│   ├── install-harbor.sh          # Installatiescript
│   └── test-harbor.sh             # Test push/pull operaties
│
├── 4.2-dockerhub-tokens/          # 🔐 Docker Hub Token Authentication
│   ├── INDEX.md                   # Overzicht van token implementatie
│   ├── README.md                  # Token setup handleiding
│   ├── kubernetes-setup.md        # Cluster configuratie + "waarom cluster?"
│   ├── setup-k8s-token.sh         # Kubernetes token setup
│   └── test-registries.sh         # Test beide registry types
│
├── kubernetes/                    # ⚓ Kubernetes Deployment Files
│   ├── deployment.yaml            # Originele deployment
│   ├── deployment-secure.yaml     # Enhanced security deployment
│   └── nginx-service.yaml         # Load balancer service
│
├── .github/workflows/             # 🔄 CI/CD Pipeline
│   ├── build.yaml                 # Enhanced pipeline met token auth
│   └── postman-tests.yml          # API testing
│
├── content/                       # 🐍 Flask Application
│   ├── app.py                     # Main application
│   ├── requirements.txt           # Dependencies
│   └── ...                        # Other app files
│
├── REGISTRY-IMPLEMENTATION.md     # 📚 Hoofdoverzicht & implementatiegids
└── PROJECT-STRUCTURE.md          # 📁 Dit bestand
```

## 🎯 Snelle Navigatie

### Voor Opdracht 4.1 (Harbor):
```bash
cd 4.1-harbor-registry/
cat INDEX.md                 # Lees overzicht
./install-harbor.sh          # Start installatie
```

### Voor Opdracht 4.2 (Docker Hub Tokens):
```bash
cd 4.2-dockerhub-tokens/
cat INDEX.md                 # Lees overzicht
./setup-k8s-token.sh [token] # Setup met jouw token
```

## 📖 Documentatie Hiërarchie

1. **PROJECT-STRUCTURE.md** (dit bestand) - Mapoverzicht
2. **REGISTRY-IMPLEMENTATION.md** - Hoofdgids voor beide opdrachten
3. **4.1-harbor-registry/INDEX.md** - Harbor specifieke gids
4. **4.2-dockerhub-tokens/INDEX.md** - Token specifieke gids
5. **Gedetailleerde README.md** bestanden in elke map

## ✅ Voordelen van Deze Structuur

- 🗂️ **Duidelijke Scheiding**: Elke opdracht in eigen map
- 📚 **Overzichtelijk**: INDEX bestanden voor snelle orientatie
- 🔧 **Functioneel**: Scripts direct uitvoerbaar in juiste context
- 📝 **Gedocumenteerd**: Meerdere niveaus van documentatie
- 🚀 **Praktisch**: Snelle navigatie en implementatie

## 🎓 Assessment Structuur

Deze organisatie toont:
- **Planning & Organisatie**: Structured approach to DevOps
- **Documentation**: Clear hierarchy and navigation
- **Automation**: Ready-to-use scripts and configurations
- **Security Focus**: Separate concerns, clear responsibilities
- **Professional Standards**: Enterprise-level project organization