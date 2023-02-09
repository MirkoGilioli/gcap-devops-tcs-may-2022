terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "4.52.0"
    }
  }
}

provider "google" {
    project = "qwiklabs-gcp-02-b1d55501563f"
    region = "us-central1"
} 