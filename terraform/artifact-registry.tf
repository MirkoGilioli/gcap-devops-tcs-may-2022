resource "google_artifact_registry_repository" "webapp-repo" {
  location      = "us-central1"
  repository_id = "webapp-repo
  description   = "This is the repository that will contains the images of the webapp"
  format        = "DOCKER"
}