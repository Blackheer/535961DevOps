# DevOps Security - Student 535961

Dit is de repository voor de DevOps Security opdracht.

## 🔒 Security Features

### Docker Scout Integration
De CI/CD pipeline bevat nu Docker Scout scanning voor vulnerability detection:

- **Build** → **Scan** → Test → Deploy pipeline
- Docker Scout detecteert CVE's in dependencies
- Pipeline faalt bij critical/high severity vulnerabilities
- Automated security reporting in GitHub

### 🧪 Testing Docker Scout

Deze commit demonstreert Docker Scout door **intentioneel kwetsbare dependencies** toe te voegen:
- `jinja2 2.10.1` - Bevat bekend critical vulnerabilities
- `requests 2.20.0` - Bevat bekend vulnerabilities

**Ga naar GitHub Actions om te zien hoe Docker Scout de pipeline laat falen! 🚨**

### 📊 Bill of Materials (BOM)
- `quoter-bom.json` - Docker Scout gegenereerde SBOM
- `quoter-syft-sbom.json` - Syft gegenereerde SPDX SBOM

