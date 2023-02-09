resource "google_container_cluster" "prod" {
    name = "prod"
    location = "us-central1-c"
    initial_node_count = 3
}

resource "google_container_cluster" "staging" {
    name = "staging"
    location = "us-central1-c"
    initial_node_count = 1
}