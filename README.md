# FastAPI on Google Cloud Run with CI/CD

This project demonstrates how to deploy a FastAPI application to Google Cloud Run using GitHub Actions for CI/CD and Terraform for Infrastructure as Code (IaC).

## Each commit to the main branch automatically:

1. **Builds a Docker image.**

2. **Pushes it to Google Artifact Registry.**

3. **Deploys the updated container to Cloud Run.**

## Prerequisites

- Google Cloud account and project
- Terraform installed
- GitHub repository
- Docker installed locally (for local development)
- `gcloud` CLI installed and authenticated

## 🚀 Features
- FastAPI app served by Uvicorn.
- Dockerized for portability.
- CI/CD pipeline with GitHub Actions.
- Terraform scripts to provision:
    - Cloud Run service
    - Artifact Registry
    - VPC + Subnet
    - Service Account with IAM bindings
- Secrets managed via GitHub Secrets and Google Secret Manager.


## Setup

1. **Clone the repository:**
    ```
    git clone https://github.com/your-username/CI-CD-Pipeline-with-GitHub-Actions-Cloud-Run-project.git
    ```
2. **🏗️ Infrastructure with Terraform:**

   ```
    cd terraform
      ```
      ```
    terraform init
    ```
    ```
    terraform plan
    ```
   ```
    terraform apply
    ```

    ### This provisions:

    - Artifact Registry

    - Cloud Run placeholder service

    - Networking (VPC + Subnet)

    - Service Account with correct roles

3. **Configure Google Cloud:**
    - Create a service account and generate a JSON key.
    - Add the service account key as a GitHub secret (`GCP_SA_KEY`).
    - Add the Project ID as a GitHub secret (`GCP_PROJECT_ID`).
    - Add the region as a GitHub secret (`GCP_REGION`).
    - Add the repo name as a GitHub secret (`GCP_REPO_NAME`).

4. **🔄 CI/CD with GitHub Actions:**
    ### Steps:
    1. **Authenticate to Google Cloud using GitHub Secrets.**

    2. **Build Docker image.**

    3. **Push to Artifact Registry.**

    4. **Deploy to Cloud Run.**
    ### Trigger:
    - Runs automatically on each `push` to `main` .
## ▶️ Local Development:

- ```pip install -r app/requirements.txt```

- ```uvicorn app.main:app --host 0.0.0.0 --port 8080```

## 🌐 Deployment:
After a successful pipeline run, your app will be available at:
- ```https://<APP_NAME>-<REGION>-a.run.app```

## 🧰 Tools Used:
- FastAPI

- Uvicorn

- Docker

- Terraform

- GitHub Actions

- Google Cloud Run

- Google Artifact Registry

- Google Secret Manager