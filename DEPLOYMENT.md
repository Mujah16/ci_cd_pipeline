# Deployment Guide

This comprehensive guide covers all aspects of deploying the XYZ Technologies Admin Module, from local development to production environments.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Local Development Deployment](#local-development-deployment)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Ansible Deployment](#ansible-deployment)
- [Jenkins CI/CD Deployment](#jenkins-cicd-deployment)
- [Environment Configuration](#environment-configuration)
- [Monitoring and Logging](#monitoring-and-logging)
- [Rollback Procedures](#rollback-procedures)
- [Troubleshooting](#troubleshooting)

---

## Overview

The XYZ Technologies Admin Module supports multiple deployment strategies:

1. **Local Development**: Direct Maven build and Tomcat deployment
2. **Docker**: Containerized deployment on Docker hosts
3. **Kubernetes**: Orchestrated deployment on K8s clusters
4. **Ansible**: Automated deployment using configuration management
5. **Jenkins CI/CD**: Fully automated pipeline deployment

### Deployment Architecture

```
Developer → Local Build → Docker Image → Docker Registry → 
Docker Host / Kubernetes Cluster → Application Running
```

---

## Prerequisites

### System Requirements

#### For Local Development
- **Java JDK**: 8 or higher
- **Maven**: 3.6+
- **Tomcat**: 8.5+ (optional, for manual deployment)
- **Git**: Latest version

#### For Docker Deployment
- **Docker**: 20.x+
- **Docker Compose**: 1.29+ (optional)
- **Docker Hub Account**: For image registry

#### For Kubernetes Deployment
- **Kubernetes**: 1.25+ (Minikube, GKE, EKS, AKS, etc.)
- **kubectl**: Latest version
- **kubeconfig**: Configured for cluster access

#### For Ansible Deployment
- **Ansible**: 2.9+
- **Python**: 3.6+
- **SSH Access**: To target hosts
- **Ansible Collections**: `community.docker`, `community.kubernetes`

#### For Jenkins Deployment
- **Jenkins**: 2.x with required plugins
- **Jenkins Plugins**: Pipeline, Docker, Ansible, Git
- **Credentials**: Docker Hub, SSH keys, Kubernetes config

### Software Installation

#### Install Java and Maven
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-8-jdk maven

# Verify installation
java -version
mvn -version
```

#### Install Docker
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Verify installation
docker --version
```

#### Install Minikube
```bash
# Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
minikube start

# Verify installation
minikube version
kubectl version --client
```

#### Install Ansible
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ansible

# Install required collections
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.kubernetes

# Verify installation
ansible --version
```

---

## Local Development Deployment

### Build the Application

```bash
# Clone the repository
git clone https://github.com/Mujah16/ci_cd_pipeline.git
cd ci_cd_pipeline

# Clean and build
mvn clean package

# The WAR file will be created at: target/XYZtechnologies-1.0.war
```

### Run Tests

```bash
# Run all tests
mvn test

# Run with coverage report
mvn clean test jacoco:report

# View coverage report
open target/site/jacoco/index.html
```

### Manual Tomcat Deployment

```bash
# Install Tomcat (if not already installed)
sudo apt install tomcat8

# Copy WAR file to Tomcat webapps
sudo cp target/XYZtechnologies-1.0.war /var/lib/tomcat8/webapps/xyz_tech.war

# Restart Tomcat
sudo systemctl restart tomcat8

# Access the application
http://localhost:8080/xyz_tech
```

### Using Embedded Tomcat (Maven)

```bash
# Run with Tomcat Maven plugin
mvn tomcat7:run

# Access the application
http://localhost:8080/XYZtechnologies-1.0
```

---

## Docker Deployment

### Build Docker Image

```bash
# Navigate to project directory
cd /var/home/joe/projects/ci_cd_pipeline

# Build the WAR file first
mvn clean package

# Copy WAR file to expected location
cp target/XYZtechnologies-1.0.war xyz_tech.war

# Build Docker image
docker build -t xyz_tech:latest .

# Verify image
docker images | grep xyz_tech
```

### Run Docker Container

```bash
# Run container
docker run -d -p 8080:8080 --name xyz_app xyz_tech:latest

# Check container status
docker ps

# View logs
docker logs xyz_app

# Access the application
http://localhost:8080/xyz_tech
```

### Docker Compose Deployment

Create `docker-compose.yml`:

```yaml
version: '3.8'
services:
  xyz-app:
    build: .
    container_name: xyz_app
    ports:
      - "8080:8080"
    restart: unless-stopped
    environment:
      - SPRING_PROFILES_ACTIVE=prod
```

Run with Docker Compose:

```bash
# Build and start
docker-compose up -d

# View logs
docker-compose logs -f

# Stop and remove
docker-compose down
```

### Push to Docker Registry

```bash
# Tag image for Docker Hub
docker tag xyz_tech:latest mujah92/xyz_tech:latest

# Login to Docker Hub
docker login

# Push image
docker push mujah92/xyz_tech:latest

# Push with build number
docker tag xyz_tech:latest mujah92/xyz_tech:123
docker push mujah92/xyz_tech:123
```

### Docker Deployment on Remote Host

```bash
# SSH to remote host
ssh user@remote-host

# Pull image
docker pull mujah92/xyz_tech:latest

# Stop existing container (if running)
docker stop xyz_app
docker rm xyz_app

# Run new container
docker run -d -p 8080:8080 --name xyz_app mujah92/xyz_tech:latest

# Verify deployment
docker ps
curl http://localhost:8080/xyz_tech
```

---

## Kubernetes Deployment

### Prerequisites

```bash
# Start Minikube (if not running)
minikube start

# Verify cluster status
minikube status
kubectl get nodes
```

### Configure Kubernetes Manifests

Update `k8s/xyz_tech_deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xyz-tech
  labels:
    app: xyz-tech
spec:
  replicas: 3
  selector:
    matchLabels:
      app: xyz-tech
  template:
    metadata:
      labels:
        app: xyz-tech
    spec:
      containers:
      - name: xyz-tech
        image: mujah92/xyz_tech:latest  # Update this tag
        ports:
        - containerPort: 8080
        imagePullPolicy: Always
```

Update `k8s/xyz_tech_service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: xyz-tech-service
spec:
  selector:
    app: xyz-tech
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer  # Use ClusterIP for internal access
```

### Deploy to Kubernetes

```bash
# Apply deployment
kubectl apply -f k8s/xyz_tech_deployment.yaml

# Apply service
kubectl apply -f k8s/xyz_tech_service.yaml

# Verify deployment
kubectl get deployments
kubectl get pods
kubectl get services
```

### Access the Application

```bash
# For Minikube with LoadBalancer
minikube service xyz-tech-service --url

# For ClusterIP service
kubectl port-forward service/xyz-tech-service 8080:80

# Access application
http://localhost:8080/xyz_tech
```

### Scale the Deployment

```bash
# Scale to 5 replicas
kubectl scale deployment xyz-tech --replicas=5

# Verify scaling
kubectl get pods
```

### Update Deployment

```bash
# Update image tag
kubectl set image deployment/xyz-tech xyz-tech=mujah92/xyz_tech:new-version

# Verify rollout status
kubectl rollout status deployment/xyz-tech

# View rollout history
kubectl rollout history deployment/xyz-tech
```

### Rollback Deployment

```bash
# Rollback to previous version
kubectl rollout undo deployment/xyz-tech

# Rollback to specific revision
kubectl rollout undo deployment/xyz-tech --to-revision=2
```

### Delete Deployment

```bash
# Delete deployment
kubectl delete deployment xyz-tech

# Delete service
kubectl delete service xyz-tech-service

# Verify deletion
kubectl get all
```

---

## Ansible Deployment

### Configure Inventory

Edit `ansible/inventory.ini`:

```ini
[docker_hosts]
192.168.70.253 ansible_ssh_user=joe ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/jenkins-ansible-key

[localhost]
127.0.0.1 ansible_connection=local
```

### Configure Ansible

Edit `ansible/ansible.cfg`:

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
retry_files_enabled = False
```

### Docker Deployment with Ansible

```bash
# Set environment variables
export BUILD_NUMBER=123
export WORKSPACE=/var/home/joe/projects/ci_cd_pipeline
export REGISTRY_USER=your_docker_username
export REGISTRY_PASS=your_docker_password

# Run Docker deployment playbook
ansible-playbook ansible/docker-deploy.yml \
  -e "registry_username=${REGISTRY_USER}" \
  -e "registry_password=${REGISTRY_PASS}" \
  -e "workspace=${WORKSPACE}" \
  -e "build_number=${BUILD_NUMBER}" \
  -e "push_to_registry=true" \
  -e "ansible_python_interpreter=/usr/bin/python3"
```

### Kubernetes Deployment with Ansible

```bash
# Set environment variables
export BUILD_NUMBER=123
export WORKSPACE=/var/home/joe/projects/ci_cd_pipeline

# Run Kubernetes deployment playbook
ansible-playbook ansible/k8s-deploy.yml \
  -e "workspace=${WORKSPACE}" \
  -e "build_number=${BUILD_NUMBER}"
```

### Dry Run Mode

```bash
# Test playbook without making changes
ansible-playbook ansible/docker-deploy.yml --check

# View what would change
ansible-playbook ansible/docker-deploy.yml --diff
```

### Verify Ansible Deployment

```bash
# Check Docker container on remote host
ssh user@docker-host
docker ps | grep xyz_app

# Check Kubernetes deployment
kubectl get pods
kubectl get services
```

---

## Jenkins CI/CD Deployment

### Jenkins Configuration

#### Install Required Plugins

1. **Pipeline Plugin**
2. **Docker Plugin**
3. **Ansible Plugin**
4. **Git Plugin**
5. **Credentials Binding Plugin**

#### Configure Credentials

1. **Docker Hub Credentials**
   - Type: Username with password
   - ID: `docker_hub_credentials`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password

2. **SSH Key for Ansible**
   - Type: SSH Username with private key
   - ID: `ansible-ssh-key`
   - Username: SSH user (e.g., joe)
   - Private Key: Private key file content

3. **Kubernetes Config**
   - Type: Secret file
   - ID: `kubeconfig`
   - File: `~/.kube/config`

#### Create Pipeline Job

1. **New Item** → Pipeline
2. **Pipeline configuration**:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: `https://github.com/Mujah16/ci_cd_pipeline.git`
   - Script Path: `Jenkinsfile`

#### Configure Build Triggers

- **Poll SCM**: Schedule with cron syntax (e.g., `H/5 * * * *`)
- **GitHub hook trigger**: Enable for automatic builds on push

### Run Jenkins Pipeline

#### Manual Trigger

1. Open Jenkins job
2. Click "Build Now"
3. Monitor pipeline stages
4. View console output

#### Automatic Trigger

Configure GitHub webhook:

1. Go to GitHub repository settings
2. Webhooks → Add webhook
3. Payload URL: `http://your-jenkins-server/github-webhook/`
4. Content type: `application/json`
5. Events: Push events

### Monitor Pipeline

```bash
# View build history in Jenkins UI
# Check console output for errors
# View stage logs for specific stage details
```

### Jenkins Pipeline Stages

1. **Code Checkout**: Clones repository
2. **Code Compile**: Maven compilation
3. **Code Test**: JUnit tests with JaCoCo
4. **Code Build**: WAR file creation
5. **Ansible Docker Build, Push and Deploy**: Docker operations
6. **Ansible K8s Deploy**: Kubernetes deployment

---

## Environment Configuration

### Development Environment

```bash
# Local development with Maven
mvn clean package
mvn tomcat7:run
```

### Staging Environment

```bash
# Docker deployment
docker build -t xyz_tech:staging .
docker run -d -p 8080:8080 --name xyz_app_staging xyz_tech:staging
```

### Production Environment

```bash
# Kubernetes deployment
kubectl apply -f k8s/xyz_tech_deployment.yaml
kubectl apply -f k8s/xyz_tech_service.yaml
```

### Environment Variables

Create `.env` file for Docker:

```bash
APP_ENV=production
APP_PORT=8080
DB_HOST=localhost
DB_PORT=3306
```

Use in Docker Compose:

```yaml
version: '3.8'
services:
  xyz-app:
    build: .
    env_file:
      - .env
    ports:
      - "${APP_PORT}:8080"
```

### Configuration Management

#### Kubernetes ConfigMaps

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: xyz-app-config
data:
  app.env: production
  app.port: "8080"
```

#### Kubernetes Secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: xyz-app-secrets
type: Opaque
data:
  db.password: <base64-encoded-password>
```

---

## Monitoring and Logging

### Application Logs

#### Docker Logs

```bash
# View container logs
docker logs xyz_app

# Follow logs in real-time
docker logs -f xyz_app

# View last 100 lines
docker logs --tail 100 xyz_app
```

#### Kubernetes Logs

```bash
# View pod logs
kubectl logs <pod-name>

# Follow logs
kubectl logs -f <pod-name>

# View logs for all pods
kubectl logs -l app=xyz-tech
```

### Monitoring with Prometheus

```bash
# Deploy Prometheus to Kubernetes
kubectl apply -f prometheus.yml

# Access Prometheus UI
kubectl port-forward service/prometheus 9090:9090
```

### Health Checks

#### Docker Health Check

Add to Dockerfile:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/xyz_tech/health || exit 1
```

#### Kubernetes Liveness Probe

Add to deployment:

```yaml
livenessProbe:
  httpGet:
    path: /xyz_tech/health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

#### Kubernetes Readiness Probe

```yaml
readinessProbe:
  httpGet:
    path: /xyz_tech/ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

---

## Rollback Procedures

### Docker Rollback

```bash
# Stop current container
docker stop xyz_app
docker rm xyz_app

# Run previous version
docker run -d -p 8080:8080 --name xyz_app mujah92/xyz_tech:previous-version

# Verify rollback
docker ps
curl http://localhost:8080/xyz_tech
```

### Kubernetes Rollback

```bash
# View rollout history
kubectl rollout history deployment/xyz-tech

# Rollback to previous version
kubectl rollout undo deployment/xyz-tech

# Rollback to specific revision
kubectl rollout undo deployment/xyz-tech --to-revision=2

# Verify rollback
kubectl rollout status deployment/xyz-tech
```

### Ansible Rollback

```bash
# Re-run playbook with previous build number
ansible-playbook ansible/docker-deploy.yml \
  -e "build_number=previous-build-number"

# For Kubernetes
ansible-playbook ansible/k8s-deploy.yml \
  -e "build_number=previous-build-number"
```

### Jenkins Rollback

1. Identify the successful build number
2. Re-run the pipeline with that build number
3. Or manually deploy the previous image version

---

## Troubleshooting

### Common Issues and Solutions

#### Build Failures

**Issue**: Maven build fails
```bash
# Solution: Clean and rebuild
mvn clean install -U

# Check Java version
java -version  # Should be Java 8
```

**Issue**: Dependencies not found
```bash
# Solution: Update Maven dependencies
mvn dependency:purge-local-repository
mvn clean install
```

#### Docker Issues

**Issue**: Docker build fails
```bash
# Solution: Check Docker daemon
sudo systemctl status docker

# Check Docker logs
sudo journalctl -u docker

# Restart Docker
sudo systemctl restart docker
```

**Issue**: Container won't start
```bash
# Solution: Check container logs
docker logs xyz_app

# Check if port is already in use
sudo lsof -i :8080

# Check image exists
docker images | grep xyz_tech
```

#### Kubernetes Issues

**Issue**: Pods not starting
```bash
# Solution: Check pod status
kubectl describe pod <pod-name>

# Check pod logs
kubectl logs <pod-name>

# Check events
kubectl get events
```

**Issue**: Service not accessible
```bash
# Solution: Check service endpoints
kubectl get endpoints xyz-tech-service

# Check service configuration
kubectl describe service xyz-tech-service

# Port forward for testing
kubectl port-forward service/xyz-tech-service 8080:80
```

#### Ansible Issues

**Issue**: SSH connection failed
```bash
# Solution: Test SSH connection
ssh -i /path/to/key user@host

# Check Ansible connectivity
ansible -i inventory.ini all -m ping

# Check SSH key permissions
chmod 600 /path/to/key
```

**Issue**: Playbook execution failed
```bash
# Solution: Run with verbose output
ansible-playbook playbook.yml -vvv

# Run in check mode
ansible-playbook playbook.yml --check

# Test specific task
ansible-playbook playbook.yml --tags "task-name"
```

#### Jenkins Issues

**Issue**: Pipeline fails at checkout
```bash
# Solution: Check Git configuration
# Verify repository URL
# Check credentials
```

**Issue**: Ansible plugin not found
```bash
# Solution: Install Ansible plugin
# Manage Jenkins → Manage Plugins → Available → Ansible Plugin
```

### Debug Mode

#### Enable Debug Logging

```bash
# Maven debug
mvn -X clean package

# Docker debug
docker build --no-cache --progress=plain -t xyz_tech:latest .

# Ansible debug
ansible-playbook playbook.yml -vvv

# Kubernetes debug
kubectl describe pod <pod-name>
```

### Log Collection

```bash
# Collect all logs
docker logs xyz_app > docker.log
kubectl logs <pod-name> > k8s.log
journalctl -u jenkins > jenkins.log
```

### Performance Issues

#### High Memory Usage

```bash
# Check container resource usage
docker stats xyz_app

# Check pod resource usage
kubectl top pods

# Limit resources in Kubernetes
kubectl set resources deployment xyz-tech --limits=memory=512Mi
```

#### Slow Startup

```bash
# Check image size
docker images xyz_tech

# Optimize Dockerfile
# Use multi-stage builds
# Minimize layers
```

---

## Best Practices

### Deployment Best Practices

1. **Always test in staging before production**
2. **Use version tags for Docker images**
3. **Implement health checks**
4. **Monitor application logs**
5. **Have rollback procedures ready**
6. **Use infrastructure as code**
7. **Automate deployments**
8. **Document deployment procedures**

### Security Best Practices

1. **Never commit secrets to repository**
2. **Use environment variables for sensitive data**
3. **Regularly update dependencies**
4. **Scan Docker images for vulnerabilities**
5. **Use least privilege for service accounts**
6. **Enable network policies in Kubernetes**
7. **Rotate credentials regularly**
8. **Audit access logs**

### Monitoring Best Practices

1. **Centralize logs**
2. **Set up alerts for critical failures**
3. **Monitor resource usage**
4. **Track application metrics**
5. **Review logs regularly**
6. **Set up dashboards**
7. **Monitor deployment success rates**

---

## Support and Resources

### Documentation

- [README.md](README.md) - Project overview
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development guidelines
- [API.md](API.md) - API documentation

### External Resources

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Maven Documentation](https://maven.apache.org/guides/)

### Getting Help

- Create an issue on GitHub
- Check existing issues for solutions
- Review documentation
- Contact maintainers

---

This deployment guide provides comprehensive instructions for deploying the XYZ Technologies Admin Module across various environments and platforms. Follow the appropriate section based on your deployment requirements.
