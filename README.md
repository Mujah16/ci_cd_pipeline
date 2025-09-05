# CI/CD Pipeline with Jenkins, Docker, and Kubernetes

This repository contains the **Final Grades project**, showcasing a fully automated **CI/CD pipeline** built with **Jenkins**, **Docker**, and **Kubernetes**.  
The pipeline demonstrates modern DevOps practices: continuous integration, automated testing, containerization, and deployment into a Kubernetes cluster.

---

## 🚀 Features

- **Automated CI/CD** with Jenkins Declarative Pipeline (`Jenkinsfile`)
- **Build & Test**: Compiles application code and runs automated unit tests
- **Containerization**: Builds a Docker image of the application
- **Artifact Management**: Stores versioned images in Docker Hub (or any registry)
- **Kubernetes Deployment**:
  - Deploys the containerized application into a Kubernetes cluster
  - Manages rollouts and rollbacks with `kubectl`
- **Stage Isolation**: Clear stages for build, test, package, deploy, and cleanup

---

## 🛠️ Pipeline Overview

The `Jenkinsfile` defines the following stages:

1. **Checkout**  
   - Fetches source code from GitHub.

2. **Build**  
   - Compiles the code (Gradle/Maven/npm depending on the project).  
   - Ensures the build artifacts are ready for packaging.

3. **Test**  
   - Executes unit and integration tests.  
   - Reports results back to Jenkins.

4. **Docker Build & Push**  
   - Builds a Docker image using the project’s `Dockerfile`.  
   - Pushes the image to Docker Hub (or a private registry).

5. **Deploy to Kubernetes**  
   - Applies Kubernetes manifests (`deployment.yaml`, `service.yaml`).  
   - Performs rolling update with zero downtime.

6. **Post Actions**  
   - Sends notifications (success/failure).  
   - Cleans up workspace.

---

## 📦 Usage Instructions

### Prerequisites
- Jenkins server with the following plugins:
  - **Pipeline**
  - **Docker**
  - **Kubernetes CLI**
- Docker installed and configured with registry credentials
- Access to a Kubernetes cluster (Minikube, GKE, EKS, AKS, etc.)

### Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/Mujah16/ci_cd_pipeline.git
   cd ci_cd_pipeline
   ```

2. **Configure Jenkins Job**
   - Create a new **Pipeline job** in Jenkins.
   - Point the job to this GitHub repo.
   - Select `Pipeline script from SCM`.

3. **Set Environment Variables in Jenkins**
   - `DOCKER_USER` → Docker registry username  
   - `DOCKER_PASS` → Docker registry password  
   - `KUBE_CONFIG` → Path to Kubernetes config (or mount inside Jenkins agent)  

4. **Run the Pipeline**
   - Trigger the pipeline manually or on `git push`.  
   - Watch Jenkins stages for build, test, Docker push, and Kubernetes deploy.

---


## 📄 Repository Structure

```
ci_cd_pipeline/
├── Jenkinsfile          # Declarative pipeline definition
├── Dockerfile           # Container build instructions
├── k8s/                 # Kubernetes deployment manifests
│   ├── deployment.yaml
│   └── service.yaml
└── src/                 # Application source code (Final Grades project)
```