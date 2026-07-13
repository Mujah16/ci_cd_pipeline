# Contributing to XYZ Technologies Admin Module

Thank you for your interest in contributing to the XYZ Technologies Admin Module project! This document provides guidelines and instructions for contributing to the codebase.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing Requirements](#testing-requirements)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Documentation Standards](#documentation-standards)
- [Issue Reporting](#issue-reporting)

---

## Getting Started

### Prerequisites

Before contributing, ensure you have the following installed:

- **Java Development Kit (JDK)** 8 or higher
- **Apache Maven** 3.6+
- **Git** for version control
- **Docker** 20.x+ (for container testing)
- **Minikube** 1.25+ (for Kubernetes testing)
- **Ansible** 2.9+ (for deployment testing)
- **IDE**: Eclipse, IntelliJ IDEA, or VS Code

### Initial Setup

1. **Fork the Repository**
   ```bash
   # Fork the repository on GitHub
   # Clone your fork locally
   git clone https://github.com/YOUR_USERNAME/devops-ci-cd-pipeline.git
   cd devops-ci-cd-pipeline
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/Mujah16/devops-ci-cd-pipeline.git
   ```

3. **Install Dependencies**
   ```bash
   mvn clean install
   ```

4. **Run Tests**
   ```bash
   mvn test
   ```

5. **Build the Project**
   ```bash
   mvn clean package
   ```

---

## Development Workflow

### Branch Strategy

We use a simplified branching model:

- **main**: Stable production-ready code
- **feature/***: New features
- **bugfix/***: Bug fixes
- **docs/***: Documentation updates
- **refactor/***: Code refactoring

### Creating a Feature Branch

```bash
# Ensure your main branch is up to date
git checkout main
git pull upstream main

# Create a new feature branch
git checkout -b feature/your-feature-name
```

### Making Changes

1. **Make your changes** following the code style guidelines
2. **Write tests** for new functionality
3. **Update documentation** as needed
4. **Run tests** to ensure everything passes
5. **Commit your changes** following commit message guidelines

### Syncing with Upstream

```bash
# Fetch upstream changes
git fetch upstream

# Rebase your branch on top of upstream main
git rebase upstream/main

# Resolve any conflicts if they arise
# Continue rebase after resolving conflicts
git rebase --continue
```

---

## Code Style Guidelines

### Java Code Style

Follow standard Java conventions:

- **Indentation**: 4 spaces (no tabs)
- **Line Length**: Maximum 120 characters
- **Braces**: K&R style (opening brace on same line)
- **Naming Conventions**:
  - Classes: `PascalCase` (e.g., `AdminModule`)
  - Methods: `camelCase` (e.g., `getUser_id`)
  - Variables: `camelCase` (e.g., `userName`)
  - Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_SIZE`)
  - Packages: `lowercase` (e.g., `com.xyz`)

### Example Java Code

```java
package com.xyz;

public class AdminModule {
    private int userId;
    private String userName;
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
}
```

### Maven Configuration

- **Java Version**: 1.8
- **Encoding**: UTF-8
- **Dependencies**: Keep them updated and minimal
- **Plugins**: Use standard Maven plugins

### YAML/Ansible Style

- **Indentation**: 2 spaces
- **Quotes**: Use single quotes for strings
- **Comments**: Explain complex logic
- **Variables**: Use descriptive names

### Example Ansible Task

```yaml
- name: Build Docker image
  community.docker.docker_image:
    name: "{{ image_name }}:{{ build_number }}"
    build:
      path: "/tmp/build"
      dockerfile: "Dockerfile"
    source: build
    force_source: yes
```

### Jenkinsfile Style

- **Indentation**: 4 spaces
- **Stage Names**: Descriptive and consistent
- **Error Handling**: Use `try-catch` blocks for critical steps
- **Comments**: Document complex pipeline logic

---

## Testing Requirements

### Unit Tests

- **Coverage**: Maintain at least 80% code coverage
- **Framework**: JUnit 4.4
- **Naming**: Test classes should end with `Test`
- **Structure**: Arrange-Act-Assert pattern

### Example Test

```java
public class AdminDataImpTest {
    
    @Test
    public void testGetUserById() {
        // Arrange
        AdminDataImp dao = new AdminDataImp();
        int expectedId = 1;
        
        // Act
        int actualId = dao.getUserById(expectedId);
        
        // Assert
        assertEquals(expectedId, actualId);
    }
}
```

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=AdminDataImpTest

# Run with coverage report
mvn clean test jacoco:report
```

### Integration Testing

- Test Docker builds locally
- Test Ansible playbooks in dry-run mode
- Test Kubernetes deployments in Minikube
- Verify end-to-end pipeline functionality

### Test Coverage

Generate and review coverage reports:

```bash
mvn clean test jacoco:report
# View report at: target/site/jacoco/index.html
```

---

## Commit Message Guidelines

### Commit Message Format

Follow the Conventional Commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **ci**: CI/CD changes

### Examples

```
feat(data-access): add user retrieval by email

Implement new method to retrieve user data by email address.
This includes database query optimization and caching.

Closes #123
```

```
fix(pipeline): resolve Docker registry authentication

Update Ansible playbook to use correct credential variables
for Docker Hub authentication.

Fixes #456
```

```
docs(readme): update installation instructions

Add detailed steps for local development setup and
prerequisites clarification.
```

### Commit Message Rules

- **Subject line**: 50 characters or less
- **Subject line**: Use imperative mood ("add" not "added")
- **Subject line**: No period at the end
- **Body**: Wrap at 72 characters
- **Body**: Explain what and why, not how
- **Footer**: Reference issue numbers

---

## Pull Request Process

### Before Submitting

1. **Ensure your branch is up to date**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run all tests**
   ```bash
   mvn clean test
   ```

3. **Build the project**
   ```bash
   mvn clean package
   ```

4. **Check code style**
   - Ensure code follows style guidelines
   - Remove debugging statements
   - Update documentation

### Creating a Pull Request

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create PR on GitHub**
   - Go to the repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

3. **PR Description Template**

   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update
   
   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Comments added for complex logic
   - [ ] Documentation updated
   - [ ] No merge conflicts
   
   ## Related Issues
   Closes #123
   ```

### PR Review Process

1. **Automated Checks**
   - CI pipeline runs automatically
   - All tests must pass
   - Code coverage must not decrease

2. **Manual Review**
   - Maintainer reviews the code
   - Feedback provided via comments
   - Address review comments

3. **Approval and Merge**
   - At least one approval required
   - Resolve all review comments
   - Squash and merge to main

### After Merge

1. **Delete your feature branch**
   ```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
   ```

2. **Update your local main**
   ```bash
   git checkout main
   git pull upstream main
   ```

---

## Documentation Standards

### Code Documentation

- **JavaDoc**: Add JavaDoc comments for public methods
- **Comments**: Explain complex logic, not obvious code
- **Examples**: Provide usage examples in documentation

### JavaDoc Example

```java
/**
 * Retrieves a user by their unique identifier.
 * 
 * @param userId The unique identifier of the user
 * @return The AdminModule object containing user data
 * @throws IllegalArgumentException if userId is negative
 */
public AdminModule getUserById(int userId) {
    // Implementation
}
```

### README Updates

- Update README.md for:
  - New features
  - Configuration changes
  - Breaking changes
  - New dependencies

### Documentation Files

- **ARCHITECTURE.md**: Update for architectural changes
- **DEPLOYMENT.md**: Update for deployment process changes
- **API.md**: Update for API changes
- **CONTRIBUTING.md**: Update for process changes

---

## Issue Reporting

### Bug Reports

When reporting bugs, include:

1. **Description**: Clear description of the bug
2. **Steps to Reproduce**: Detailed steps to reproduce the issue
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**: 
   - OS version
   - Java version
   - Maven version
   - Docker version
6. **Logs**: Relevant error logs or stack traces
7. **Screenshots**: If applicable

### Feature Requests

When requesting features, include:

1. **Description**: Clear description of the feature
2. **Use Case**: Why this feature is needed
3. **Proposed Solution**: How you envision the feature
4. **Alternatives**: Alternative approaches considered
5. **Additional Context**: Any other relevant information

### Issue Template

```markdown
## Issue Type
- [ ] Bug
- [ ] Feature Request
- [ ] Documentation Issue
- [ ] Other

## Description
[Clear description of the issue]

## Steps to Reproduce (for bugs)
1. 
2. 
3. 

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: 
- Java Version: 
- Maven Version: 
- Docker Version: 

## Logs/Screenshots
[Paste logs or attach screenshots]

## Additional Context
[Any other relevant information]
```

---

## Development Best Practices

### Code Review

- **Self-review**: Review your own code before submitting
- **Keep changes small**: Smaller PRs are easier to review
- **Focus on one thing**: Each PR should address one issue
- **Test thoroughly**: Ensure tests cover new functionality

### Security

- **No secrets in code**: Never commit passwords or API keys
- **Use environment variables**: Configure sensitive data via environment
- **Review dependencies**: Check for security vulnerabilities
- **Follow security best practices**: Validate inputs, sanitize outputs

### Performance

- **Optimize database queries**: Use efficient queries
- **Cache appropriately**: Cache frequently accessed data
- **Profile code**: Identify bottlenecks before optimizing
- **Measure improvements**: Use metrics to validate performance gains

### Maintainability

- **Write clean code**: Code should be self-documenting
- **Avoid duplication**: Follow DRY principle
- **Use meaningful names**: Variable and function names should be descriptive
- **Keep it simple**: Avoid over-engineering

---

## Getting Help

If you need help:

1. **Check existing documentation**: README, ARCHITECTURE, DEPLOYMENT
2. **Search existing issues**: Your question may already be answered
3. **Ask in issues**: Create an issue with your question
4. **Contact maintainers**: Reach out via GitHub issues

---

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

---

## Code of Conduct

Be respectful and constructive in all interactions. We welcome contributors from diverse backgrounds and perspectives. Harassment or disrespectful behavior will not be tolerated.

---

Thank you for contributing to the XYZ Technologies Admin Module project! Your contributions help make this project better for everyone.
