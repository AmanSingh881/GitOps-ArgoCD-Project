# Jenkins CI Pipeline with SonarQube, OWASP Dependency Check, AWS ECR, and AWS Secrets Manager

## 📌 Project Overview
This project demonstrates a **Jenkins CI pipeline** that automates the process of building, analyzing, securing, and deploying a Dockerized application to **Amazon Elastic Container Registry (ECR)**.  

The pipeline includes:
- **GitHub Source Integration** – Pulls the application code from GitHub.  
- **Static Code Analysis with SonarQube** – Ensures code quality and maintainability.  
- **Dependency Scanning with OWASP Dependency-Check** – Identifies vulnerable dependencies.  
- **Docker Image Build** – Builds a container image from the application code.  
- **Image Push to AWS ECR** – Securely pushes the built image to AWS ECR.  
- **Helm Chart Automation** – Updates Helm values.yaml with the new image tag.
- **Pull Request Creation in GitHub** – Creates a PR for deployment automation.
- **Secrets Management with AWS Secrets Manager** – Stores sensitive information such as AWS 
credentials, repository URIs, and other Jenkins secrets securely.  
- **Post-Build Cleanup** – Removes unused images from Jenkins agent to save space.  

---

## ⚙️ Pipeline Workflow
![Pipeline Flow](Assets/CIworkflow.png)  

1. **Checkout Code**  
   - Clones the source code from GitHub (`main` branch).

2. **Static Code Analysis (SonarQube)**  
   - Runs `sonar-scanner` with project-specific details.  
   - Ensures code adheres to quality and reliability standards.  

3. **Quality Gate Check**
   - Waits for SonarQube Quality Gate result.
   - If quality gate fails (too many issues, low coverage), pipeline aborts.

4. **Dependency Security Check (OWASP)**  
   - Scans dependencies for known vulnerabilities.  
   - Generates security reports.
   - Enable SonarQube **Quality Gate** stage (currently commented in pipeline).  

5. **Docker Image Build**  
   - Builds the Docker image using the provided `Dockerfile`.  

6. **Push to AWS ECR**  
   - Authenticates with AWS ECR using `aws ecr get-login-password`.  
   - Tags the image correctly and pushes it to the AWS ECR repository.  

7. **Update Helm Chart & Create Pull Request**
   - Clones the repository again into a `featurebranch` branch.
   - Updates the Helm `values.yaml` file with the new image tag.
   - Commits and pushes the changes.
   - Creates a `Pull Request` in GitHub targeting the `main` branch.
   - Ensures deployments always pick up the latest image tag.

8. **Cleanup**  
   - Removes local Docker images and prunes unused layers.  


---

## 🔑 Prerequisites
To run this pipeline successfully, ensure the following are available:

1. **Jenkins Setup**
   - Jenkins installed with the following plugins:
     - Git Plugin  
     - Pipeline Plugin  
     - SonarQube Scanner for Jenkins  
     - OWASP Dependency-Check Plugin  
     - Docker Pipeline Plugin  

   - Installed tools on Jenkins agents:
     - AWS CLI
     - Docker
     - GitHub CLI (gh)
     - yq (YAML processor)

2. **SonarQube**
   - SonarQube server running and accessible from Jenkins.  
   - SonarQube tool configured in Jenkins (e.g., name: `Sonar`).  
   - SonarQube project and token configured.  

3. **OWASP Dependency-Check**
   - Installed and configured in Jenkins (installation name: `DP-Check`).  

4. **AWS Setup**
   - AWS CLI installed and configured on Jenkins agents.  
   - AWS ECR repository created in AWS account.  
   - **AWS Secrets Manager used to securely store Jenkins credentials** such as:
     - Repository URI  
     - Image repo name  
     - Region  
     - Account ID  
     - AWS authentication keys  

5. **GitHub Setup**
   - GitHub repository for source code + Helm chart.
   - Personal Access Token with repo & PR permissions added in Jenkins credentials.

   ![Pipeline Flow](Assets/Github-token-permission.png)


---

## 🔧 Jenkins Pipeline Parameters
| Parameter Name   | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `DEPLOY_VERSION` | The version tag for the Docker image. This will be used in build and deploy.|

---

## 🌐 Environment Variables in Jenkinsfile
| Variable           | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `IMAGE_TAG`        | Docker image tag (taken from `DEPLOY_VERSION`).                             |
| `REPOSITORY_URI`   | AWS ECR repository URI (retrieved from AWS Secrets Manager).                |
| `IMAGE_REPO_NAME`  | Name of the Docker image repository (retrieved from AWS Secrets Manager).   |
| `REGION`           | AWS region where ECR is created (retrieved from AWS Secrets Manager).       |  
| `ACCOUNT_ID`       | AWS Account ID (retrieved from AWS Secrets Manager).                        |
| `REPO_BRANCH`	   | Target branch for PR (main).                                                |
| `HELM_CHART_PATH`	| Path to Helm chart values file (e.g., my-helm-chart/values.yaml).           |
| `GITHUB_TOKEN_ID`	|GitHub token credential ID in Jenkins.                                       |
| `SONAR_HOME`       | Path to the SonarQube scanner tool.                                            |

## ⚙️ Secrets in Secret Manager AWS
![Pipeline Flow](Assets/Secrets.png) 
---

## 🚀 Running the Pipeline
1. Commit and push your changes to the GitHub repository.  
2. In Jenkins, create a new pipeline project and point it to this repository.  
3. Add required secrets in **AWS Secrets Manager**, and configure Jenkins to fetch them dynamically.  
4. Run the pipeline and provide `DEPLOY_VERSION` when prompted.  
5. Verify:
   1. Docker image in AWS ECR
   2. Pull Request created in GitHub with updated Helm values  

---

## 📊 Security & Quality Tools
- **SonarQube**: Helps maintain clean, safe, and reliable code.  
- **OWASP Dependency-Check**: Detects security vulnerabilities in project dependencies.  
- **AWS Secrets Manager**: Protects sensitive data by avoiding plain text credentials in Jenkins.  

---

## 🧹 Cleanup Policy
After every build, the pipeline automatically:
- Removes local Docker images built during the pipeline run.  
- Prunes unused Docker layers to free disk space.  

---

## 📌 Future Enhancements
- Add automated deployment to AWS ECS or Kubernetes (EKS).  
- Add email or Slack notifications for build results.  

---

