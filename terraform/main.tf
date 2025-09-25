# Enable APIs
resource "google_project_service" "cloud_run" {
    project = var.project_id
    service = "run.googleapis.com"
}

resource "google_project_service" "artifact_registry" {
    project = var.project_id
    service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "secret_manager" {
    project = var.project_id
    service = "secretmanager.googleapis.com"
}

# VPC + Subnet
resource "google_compute_network" "vpc" {
    name                    = "${var.app_name}-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
    name          = "${var.app_name}-subnet"
    ip_cidr_range = "10.0.0.0/24"
    region        = var.region
    network       = google_compute_network.vpc.id

}

# Artifact Registry (docker)
resource "google_artifact_registry_repository" "repo" {
    provider     = google
    location     = var.region
    repository_id = "${var.app_name}-repo"
    description  = "Docker repo for Cloud Run"
    format       = "DOCKER"

}

# Service Account for CI/CD deployments (created by Terraform)

resource "google_service_account" "ci_deployer" {
    account_id   = "${var.app_name}-ci-deployer"
    display_name = "CI Deployer Service Account"
}

# IAM bindings for the CI deployer SA

resource "google_project_iam_member" "sa_run_admin" {
  project = var.project_id
    role    = "roles/run.admin"
    member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}

resource "google_project_iam_member" "sa_artifact_writer" {
  project = var.project_id
    role    = "roles/artifactregistry.writer"
    member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}



# Allow pushing image to Artifact Registry
resource "google_project_iam_member" "sa_storage_admin" {
  project = var.project_id
    role    = "roles/storage.admin"
    member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}

# Allow accessing secrets
resource "google_project_iam_member" "sa_secret_accessor" {
  project = var.project_id
    role    = "roles/secretmanager.secretAccessor"
    member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}


# Allow the CI/CD pipeline SA to impersonate this SA

resource "google_project_iam_member" "sa_impersonate" {
  project = var.project_id
    role    = "roles/iam.serviceAccountUser"
    member  = "serviceAccount:${google_service_account.ci_deployer.email}"
}

# Cloud Run placeholder service (v2)

resource "google_cloud_run_v2_service" "service" {
    name     = var.app_name
    location = var.region

    template {
        containers {
            # # Placeholder public hello image
            # image = "us-docker.pkg.dev/cloudrun/container/hello"
            image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.app_name}-repo/${var.app_name}:latest"
        }
    }
}