# 🚢 Harbor On-Premise Registry - Opdracht 4.1

Deze map bevat alle bestanden voor de implementatie van Harbor als on-premise registry.

## 📁 Bestandsoverzicht

| Bestand | Beschrijving |
|---------|--------------|
| `harbor-values.yaml` | Helm configuratie voor Harbor installatie |
| `install-harbor.sh` | Installatiescript voor Harbor op Kubernetes |
| `test-harbor.sh` | Basis test script voor push/pull operaties |
| `harbor-push-pull-demo.sh` | **Complete demonstratie script** met alle stappen |
| `README.md` | Gedetailleerde installatie en configuratie handleiding |
| `HARBOR-AUTHENTICATION-GUIDE.md` | **Complete gids voor alle authenticatie methoden** |
| `PUSH-PULL-DEMONSTRATION.md` | **Stap-voor-stap push/pull demonstratie** |

## 🚀 Snelle Start

### Voor Harbor Installatie:
```bash
# Navigeer naar deze map
cd 4.1-harbor-registry/

# Maak scripts uitvoerbaar
chmod +x install-harbor.sh test-harbor.sh harbor-push-pull-demo.sh

# Start Harbor installatie
./install-harbor.sh
```

### Voor Push/Pull Demonstratie:
```bash
# Voer complete demonstratie uit
./harbor-push-pull-demo.sh

# Of volg stap-voor-stap gids
cat PUSH-PULL-DEMONSTRATION.md
```

### Voor Authenticatie Configuratie:
```bash
# Lees complete authenticatie gids
cat HARBOR-AUTHENTICATION-GUIDE.md
```

## 🔐 Veiligheidsfeatures

- ✅ HTTPS met private certificaten
- ✅ Meerdere authenticatie methoden
- ✅ RBAC (Role-Based Access Control)
- ✅ Vulnerability scanning met Trivy
- ✅ Image signing met Notary
- ✅ Audit logging

## 📚 Documentatie

### Implementatie Gidsen:
- **`README.md`** - Basis installatie en configuratie
- **`PUSH-PULL-DEMONSTRATION.md`** - Complete stap-voor-stap demonstratie
- **`HARBOR-AUTHENTICATION-GUIDE.md`** - Alle authenticatie methoden uitgelegd

### Wat je vindt in elke gids:
- **README.md**: Installatie instructies, HTTPS certificaten, troubleshooting
- **PUSH-PULL-DEMONSTRATION.md**: Bewijs dat push/pull werkt met screenshots en commands
- **HARBOR-AUTHENTICATION-GUIDE.md**: 6 authenticatie methoden met voorbeelden en use cases