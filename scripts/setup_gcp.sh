#!/usr/bin/env bash
set -euo pipefail

#Load variables from (.env or GitHub secrets)
PROJECT_ID="${GCP_PROJECT_ID}"
REGION="${GCP_REGION:-us-central1}"
REPO_NAME="${GCP_REPO_NAME:-ci-cd-cloud-run}"
SERVICE_ACCOUNT_NAME="${GCP_SA_NAME:-github-actions-cloud-run}"

echo "Enabling required services..."

gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    artifactregistry.googleapis.com \
    secretmanager.googleapis.com

echo "Creating Artifact Registry repository if it doesn't exist..."

if ! gcloud artifacts repositories describe "$REPO_NAME" \
    --location="$REGION" > /dev/null 2>&1; then
    gcloud artifacts repositories create "$REPO_NAME" \
        --repository-format=docker \
        --location="$REGION" \
        --description="Docker repository for Cloud Run images"

else
    echo "✅Repository $REPO_NAME already exists. Skipping creation."

fi

echo "Creating service account if it doesn't exist..."
if ! gcloud iam service-accounts describe "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" > /dev/null 2>&1; then
    gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
        --display-name="GitHub Actions Deploy"
else
    echo "✅Service account $SERVICE_ACCOUNT_NAME already exists. Skipping creation."

fi

echo "Assigning roles to the service account..."

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.writer"

echo "✅ GCP setup completed successfully."
