# CI/CD Pipeline (Java • Maven • Jenkins • Docker • Kubernetes)

> End-to-end sample showing how to build, containerize, and deploy a Java application with a Jenkins pipeline, plus k8s manifests, Ansible automation, and basic Prometheus config. Repo structure includes `src/`, `pom.xml`, `Dockerfile`, `Jenkinsfile`, `k8s/`, `ansible/`, and `prometheus.yml`.

## 🚀 What this repo gives you

- **Java/Maven app** scaffolded under `src/` with a `pom.xml` for builds.  
- **Jenkins pipeline** (`Jenkinsfile`) for CI/CD (build → test → Docker build/push → deploy).  
- **Containerization** via `Dockerfile`.  
- **Kubernetes manifests** in `/k8s` for deploying to a cluster.  
- **Ansible** playbooks/roles in `/ansible` for environment automation.  
- **Prometheus** scrape config (`prometheus.yml`) as a starter for metrics.

---

## 🧭 Architecture (high level)

```mermaid
flowchart LR
  A[GitHub Repo] -->|Webhook| B[Jenkins]
  B --> C[Build & Test (Maven)]
  C --> D[Docker Build]
  D --> E[(Container Registry)]
  E --> F[Kubernetes Deploy (k8s/)]
  B --> G[Ansible Tasks (ansible/)]
  F --> H[Running App]
  H --> I[Prometheus Scrape (prometheus.yml)]
```

---

## 📁 Repository layout

```
.
├─ src/                 # Java source code
├─ pom.xml              # Maven project descriptor
├─ Dockerfile           # Container image build
├─ Jenkinsfile          # Declarative pipeline
├─ k8s/                 # Deployment/service manifests
├─ ansible/             # Infra/app automation
├─ prometheus.yml       # Prometheus scrape config
└─ README.md
```

> Languages detected: **Java** (~96%) and **Dockerfile** (~4%).

---

## ⚙️ Prerequisites

- Java 17+ (adjust if your `pom.xml` targets a different version)
- Maven 3.8+  
- Docker (for local image builds)  
- Access to a container registry (e.g., Docker Hub, ECR, ACR)  
- A Kubernetes cluster + `kubectl` configured (optional, for deploy)  
- Jenkins with Docker and Kubernetes/CLI tools on the agent (for CI/CD)

---

## 🏗️ Local build & run

**Build & test**

```bash
mvn clean package
```

**Run locally (JAR)**

```bash
java -jar target/*.jar
```

> If the app uses Spring Boot, the fat JAR in `target/` will start the service on the configured port.

---

## 🐳 Build & run with Docker

**Build image**

```bash
docker build -t your-registry/your-image:dev .
```

**Run container**

```bash
docker run --rm -p 8080:8080 your-registry/your-image:dev
```

> Replace `your-registry/your-image` with your actual registry/name.

---

## ☸️ Deploy to Kubernetes

1. Make sure the image is available in your cluster (push it or use a local registry).
2. Apply manifests:

```bash
kubectl apply -f k8s/
```

3. Check resources:

```bash
kubectl get deploy,svc,pods
```

> Tweak `k8s/` manifests to reference your image and desired resources.

---

## 🤖 Jenkins CI/CD

The `Jenkinsfile` is a declarative pipeline that typically runs:

1. **Checkout** → pull from this repo  
2. **Build & Test** → `mvn -B clean package`  
3. **Docker Build & Push** → build and push to your registry  
4. **Deploy**  
   - Option A: `kubectl apply -f k8s/` to target cluster  
   - Option B: Run Ansible tasks for VM/bare-metal targets

### Suggested Jenkins credentials & vars

- **REGISTRY_CRED**: Docker/registry credentials  
- **KUBE_CONFIG** or in-agent `kubectl` context  
- **ANSIBLE_VARS**/inventory (if using Ansible)  
- Any app-specific **ENV VARS/SECRETS** (inject via Jenkins credentials binding)

---

## 🧰 Ansible (optional)

Place inventories, roles, and playbooks under `ansible/` to:

- Provision hosts (Java runtime, Docker, etc.)
- Deploy the built artifact/container to VMs
- Manage service lifecycles

Run example:

```bash
ansible-playbook -i inventory.ini ansible/deploy.yml
```

---

## 📈 Prometheus

`prometheus.yml` provides a starter scrape configuration. Point Prometheus to your service endpoints or service monitors as needed.

---

## 🔐 Configuration & secrets

- Prefer **environment variables** for runtime configuration.
- Inject secrets via:
  - Jenkins Credentials + env binding
  - Kubernetes **Secrets** (referenced in `k8s/` manifests)
  - Ansible **vault** for encrypted variables

---

## 🧪 Testing

- Unit tests run with Maven during the build stage.
- Add integration tests (e.g., Testcontainers) to validate the Dockerized service before pushing.

---

## 🩹 Troubleshooting

- **Build fails:** run `mvn -X clean package` and check dependency/resolver logs.
- **Image won’t run:** verify `Dockerfile` `EXPOSE`/entrypoint and the app’s server port.
- **K8s deploy errors:** check `kubectl describe` for events; ensure image pull secrets and correct image tag.
- **Jenkins stage fails:** open the stage logs; confirm credentials and CLI tools on the agent.

---

## 🗺️ Roadmap (ideas)

- Add GitHub Actions workflow as an alternative CI.
- Add Helm chart for templated k8s deploys.
- Wire Prometheus to Grafana dashboards.
- Add SonarQube stage for code quality & coverage.

---

## 📜 License

Specify a license (e.g., MIT/Apache-2.0) in `LICENSE`.

---

## 🙌 Contributions

Issues and PRs are welcome. Please open an issue first for major changes.

---

**Author:** @Mujah16  
**Repo:** `ci_cd_pipeline`
