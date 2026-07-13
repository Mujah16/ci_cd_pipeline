# System Architecture

This document provides a comprehensive overview of the XYZ Technologies Admin Module system architecture, including component interactions, data flow, and infrastructure design.

## Table of Contents

- [Overview](#overview)
- [System Components](#system-components)
- [Architecture Diagram](#architecture-diagram)
- [Component Details](#component-details)
- [Data Flow](#data-flow)
- [Infrastructure Architecture](#infrastructure-architecture)
- [Security Architecture](#security-architecture)
- [Scalability Considerations](#scalability-considerations)
- [Technology Stack](#technology-stack)

---

## Overview

The XYZ Technologies Admin Module follows a modern microservices-inspired architecture with containerization and orchestration. The system is designed to demonstrate DevOps best practices including continuous integration, automated testing, containerization, and deployment to Kubernetes.

### Key Architectural Principles

- **Separation of Concerns**: Clear boundaries between application logic, deployment automation, and infrastructure
- **Infrastructure as Code**: All deployment configurations are version-controlled
- **Containerization**: Application runs in isolated containers for consistency
- **Automation**: Manual processes are minimized through CI/CD pipelines
- **Scalability**: Kubernetes enables horizontal scaling
- **Observability**: Monitoring and logging are integrated

---

## System Components

### Application Layer

- **AdminModule.java**: Core business logic for user management
- **Data Access Layer**: DAO pattern implementation for data operations
- **Web Interface**: JSP-based user interface
- **Servlet Container**: Apache Tomcat for web application hosting

### CI/CD Layer

- **Jenkins Pipeline**: Orchestrates the entire build and deployment process
- **Maven Build System**: Compiles, tests, and packages the application
- **JUnit Testing Framework**: Executes unit tests
- **JaCoCo**: Provides code coverage analysis

### Container Layer

- **Docker**: Container runtime for application packaging
- **Docker Registry**: Stores and distributes container images
- **Dockerfile**: Defines container build process

### Orchestration Layer

- **Kubernetes**: Container orchestration platform
- **Minikube**: Local Kubernetes development environment
- **Kubernetes Manifests**: Declarative configuration for deployments and services

### Configuration Management Layer

- **Ansible**: Automates Docker and Kubernetes deployments
- **Ansible Playbooks**: Reusable deployment scripts
- **Inventory Management**: Defines target hosts and configurations

### Monitoring Layer

- **Prometheus**: Metrics collection and monitoring
- **Service Discovery**: Automatic detection of Kubernetes services

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Developer Workflow                        │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                          GitHub Repository                        │
│  - Source Code                                                    │
│  - Configuration Files                                           │
│  - Documentation                                                  │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼ (Webhook)
┌─────────────────────────────────────────────────────────────────┐
│                            Jenkins Server                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   Jenkins Pipeline                        │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │ Checkout │→ │ Compile  │→ │   Test   │→ │  Build   │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  │                                                        │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │  Docker  │→ │  Push    │→ │  Ansible │→ │   K8s    │ │  │
│  │  │  Build   │  │ Registry │  │  Deploy  │  │  Deploy  │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    ▼                               ▼
┌───────────────────────────────┐   ┌───────────────────────────────┐
│      Docker Host              │   │      Kubernetes Cluster        │
│  ┌─────────────────────────┐  │   │  ┌─────────────────────────┐  │
│  │   Docker Container      │  │   │  │   Kubernetes Pods       │  │
│  │   - Tomcat              │  │   │  │   - Pod 1 (Replica)     │  │
│  │   - Application WAR     │  │   │  │   - Pod 2 (Replica)     │  │
│  │   - Port 8080           │  │   │  │   - Pod 3 (Replica)     │  │
│  └─────────────────────────┘  │   │  └─────────────────────────┘  │
└───────────────────────────────┘   │  ┌─────────────────────────┐  │
                                      │  │   Kubernetes Service    │  │
                                      │  │   - Load Balancer      │  │
                                      │  │   - Service Discovery  │  │
                                      │  └─────────────────────────┘  │
                                      └───────────────────────────────┘
                                                    │
                                                    ▼
                                      ┌───────────────────────────────┐
                                      │      Monitoring Layer         │
                                      │  ┌─────────────────────────┐  │
                                      │  │   Prometheus            │  │
                                      │  │   - Metrics Collection  │  │
                                      │  │   - Alerting            │  │
                                      │  └─────────────────────────┘  │
                                      └───────────────────────────────┘
```

---

## Component Details

### Application Architecture

#### AdminModule.java
The core business logic component that manages user data:
- **Properties**: user_id, user_name, user_emailId, age
- **Methods**: Getters and setters for all properties
- **Pattern**: Plain Old Java Object (POJO)

#### Data Access Layer
Implements the Data Access Object (DAO) pattern:
- **Interface**: `AdminDataAccessObject` - Defines contract for data operations
- **Implementation**: `AdminDataImp` - Concrete implementation of data operations
- **Testing**: `AdminDataImpTest` - Unit tests for data access logic

#### Web Layer
- **web.xml**: Servlet container configuration
- **index.jsp**: Application entry point and user interface
- **WAR Packaging**: Standard Java web application archive

### CI/CD Architecture

#### Jenkins Pipeline
Declarative pipeline with six main stages:

1. **Code Checkout**
   - Git integration
   - Workspace management
   - Branch handling

2. **Code Compile**
   - Maven compilation
   - Dependency resolution
   - Source validation

3. **Code Test**
   - JUnit test execution
   - Test reporting
   - Coverage analysis with JaCoCo

4. **Code Build**
   - WAR file creation
   - Artifact naming
   - Build artifact stashing

5. **Ansible Docker Build, Push and Deploy**
   - Docker image creation
   - Registry authentication
   - Image pushing
   - Container deployment

6. **Ansible K8s Deploy**
   - Manifest template updating
   - Kubernetes deployment
   - Service exposure
   - URL retrieval

### Container Architecture

#### Docker Image
- **Base Image**: `iamdevopstrainer/tomcat:base`
- **Application Layer**: WAR file deployment
- **Configuration**: Port 8080 exposure
- **Startup Command**: Catalina startup script

#### Image Tagging Strategy
- Format: `mujah92/xyz_tech:BUILD_NUMBER`
- Versioning: Jenkins build number
- Registry: Docker Hub

### Kubernetes Architecture

#### Deployment Configuration
- **Replicas**: 3 pods for high availability
- **Strategy**: Rolling update for zero downtime
- **Image Pull Policy**: Always (ensures latest image)
- **Resource Management**: Default Kubernetes scheduling

#### Service Configuration
- **Type**: ClusterIP (internal cluster access)
- **Selector**: app=xyz-tech
- **Port Mapping**: Container port 8080
- **Service Discovery**: Kubernetes DNS

### Ansible Architecture

#### Docker Deployment Playbook
- **Target**: docker_hosts group
- **Privilege Escalation**: Yes (become)
- **Tasks**:
  1. Build directory creation
  2. WAR file copying
  3. Dockerfile copying
  4. Image building
  5. Registry authentication
  6. Image pushing
  7. Container deployment

#### Kubernetes Deployment Playbook
- **Target**: localhost
- **Connection**: Local
- **Tasks**:
  1. kubectl validation
  2. Manifest template updating
  3. Kubernetes deployment
  4. Service URL retrieval

---

## Data Flow

### Build Process Flow

1. **Source Code Commit**
   ```
   Developer → Git Push → GitHub Repository
   ```

2. **Pipeline Trigger**
   ```
   GitHub Webhook → Jenkins Server → Pipeline Execution
   ```

3. **Build and Test**
   ```
   Jenkins → Maven Compile → Maven Test → JaCoCo Report
   ```

4. **Artifact Creation**
   ```
   Maven Package → WAR File → Jenkins Stash
   ```

5. **Container Build**
   ```
   Jenkins → Ansible → Docker Build → Docker Image
   ```

6. **Registry Push**
   ```
   Ansible → Docker Login → Docker Push → Docker Hub
   ```

7. **Container Deployment**
   ```
   Ansible → Docker Run → Container Start → Application Running
   ```

8. **Kubernetes Deployment**
   ```
   Ansible → kubectl apply → Deployment Update → Pod Rolling Update
   ```

### Runtime Data Flow

```
User Request → Kubernetes Service → Pod Selection → Tomcat Container → 
Application Logic → Data Access Layer → Response → User
```

---

## Infrastructure Architecture

### Development Environment

- **Local Development**: Maven build system
- **Version Control**: Git and GitHub
- **IDE Support**: Eclipse/IntelliJ (based on .classpath/.project files)

### CI/CD Environment

- **Build Server**: Jenkins
- **Agent Configuration**: Label-based agent selection
- **Credential Management**: Jenkins credentials store
- **Workspace Management**: Jenkins workspace isolation

### Container Registry

- **Registry**: Docker Hub
- **Image Naming**: `mujah92/xyz_tech:BUILD_NUMBER`
- **Authentication**: Username/password credentials
- **Access Control**: Public repository

### Container Runtime

- **Docker Host**: Remote server (192.168.70.253)
- **SSH Access**: Key-based authentication
- **Container Management**: Ansible automation
- **Port Mapping**: 8080:8080

### Kubernetes Cluster

- **Platform**: Minikube (local development)
- **Node Configuration**: Single-node cluster
- **Network**: Minikube network overlay
- **Storage**: EmptyDir (ephemeral)

---

## Security Architecture

### Credential Management

- **Jenkins Credentials**: Secure credential storage
- **Docker Registry**: Username/password authentication
- **SSH Keys**: Key-based authentication for Ansible
- **Kubernetes Config**: kubeconfig file management

### Network Security

- **SSH**: Key-based authentication to Docker host
- **Kubernetes**: Network policies (default allow)
- **Service Exposure**: ClusterIP (internal only)
- **Port Mapping**: Explicit port configuration

### Container Security

- **Base Image**: Trusted Tomcat base image
- **Image Scanning**: Manual verification recommended
- **Runtime Security**: Default Docker security settings
- **Privilege**: No privileged containers

---

## Scalability Considerations

### Horizontal Scaling

- **Kubernetes Replicas**: Configurable replica count (currently 3)
- **Load Balancing**: Kubernetes Service distributes traffic
- **Auto-scaling**: Can be enabled with Horizontal Pod Autoscaler

### Vertical Scaling

- **Resource Limits**: Can be added to deployment manifests
- **JVM Tuning**: Tomcat JVM parameters configurable
- **Container Resources**: Docker resource constraints

### CI/CD Scaling

- **Jenkins Agents**: Multiple agents for parallel execution
- **Docker Registry**: Can use private registry for enterprise
- **Kubernetes Cluster**: Can migrate to managed K8s services

---

## Technology Stack

### Application Layer

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Language | Java | 8 | Application development |
| Build Tool | Maven | 3.6+ | Dependency management and build |
| Web Framework | JSP/Servlet | 3.x | Web interface |
| Testing | JUnit | 4.4 | Unit testing |
| Coverage | JaCoCo | 0.8.6 | Code coverage analysis |

### CI/CD Layer

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| CI Server | Jenkins | 2.x | Pipeline orchestration |
| Pipeline | Declarative Pipeline | Latest | Build automation |
| SCM | Git | Latest | Version control |
| Code Hosting | GitHub | - | Repository hosting |

### Container Layer

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Container Runtime | Docker | 20.x+ | Container management |
| Base Image | Tomcat | Base | Application server |
| Registry | Docker Hub | - | Image distribution |

### Orchestration Layer

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Orchestration | Kubernetes | 1.25+ | Container orchestration |
| Local K8s | Minikube | 1.25+ | Local development |
| CLI | kubectl | Latest | Cluster management |

### Configuration Management

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Automation | Ansible | 2.9+ | Configuration management |
| Inventory | INI | - | Host definitions |
| Playbooks | YAML | - | Automation scripts |

### Monitoring

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Monitoring | Prometheus | Latest | Metrics collection |
| Configuration | YAML | - | Prometheus config |

---

## Future Enhancements

### Planned Improvements

1. **Database Integration**: Add persistent database layer
2. **API Documentation**: Implement Swagger/OpenAPI
3. **Enhanced Monitoring**: Add Grafana dashboards
4. **Security Hardening**: Implement RBAC in Kubernetes
5. **CI/CD Enhancements**: Add security scanning stages
6. **Multi-environment**: Support dev/staging/production environments
7. **Infrastructure as Code**: Add Terraform for infrastructure provisioning
8. **Logging**: Implement centralized logging with ELK stack

### Scalability Roadmap

1. **Horizontal Pod Autoscaler**: Automatic scaling based on CPU/memory
2. **Load Balancer**: External load balancer for production
3. **Database Scaling**: Read replicas and connection pooling
4. **Caching Layer**: Redis for session management
5. **CDN Integration**: Static asset delivery optimization

---

## Conclusion

The XYZ Technologies Admin Module architecture demonstrates modern DevOps practices with a focus on automation, containerization, and orchestration. The system is designed to be scalable, maintainable, and observable, providing a solid foundation for future enhancements.

The separation of concerns between application logic, CI/CD automation, and infrastructure management ensures that each layer can evolve independently while maintaining system integrity.
