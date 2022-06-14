echo "CREATING K8S CLUSTER..."
gcloud container clusters create spinnaker-tutorial --machine-type=n1-standard-2 --zone=us-central1-a
sleep 10m
echo "CREATING SPINNAKER SERVICE ACCOUNT..."
gcloud iam service-accounts create spinnaker-account --display-name spinnaker-account
export SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:spinnaker-account" --format='value(email)')
export PROJECT=$(gcloud info --format='value(config.project)')
gcloud projects add-iam-policy-binding $PROJECT --role roles/storage.admin --member serviceAccount:$SA_EMAIL
sleep 10
gcloud iam service-accounts keys create spinnaker-sa.json --iam-account $SA_EMAIL
echo "CREATING PUBSUB TOPIC AND SUBSCRIBE SPINNAKER SA..."
gcloud pubsub topics create projects/$PROJECT/topics/gcr
sleep 10
gcloud pubsub subscriptions create gcr-triggers --topic projects/${PROJECT}/topics/gcr
sleep 10
export SA_EMAIL=$(gcloud iam service-accounts list --filter="displayName:spinnaker-account" --format='value(email)')
gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL
echo "ASSIGN CLUSTER ADMIN ROLE"
kubectl create clusterrolebinding user-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)
sleep 10
kubectl create clusterrolebinding --clusterrole=cluster-admin --serviceaccount=default:default spinnaker-admin
echo "INSTALL SPINNAKER USING HELM..."
helm repo add stable https://charts.helm.sh/stable
helm repo update
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
gsutil mb -c regional -l us-central1 gs://$BUCKET
sleep 10
export SA_JSON=$(cat spinnaker-sa.json)
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'
dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com
# Disable minio as the default storage backend
minio:
  enabled: false
# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF
helm install -n default cd stable/spinnaker -f spinnaker-config.yaml --version 2.0.0-rc9 --timeout 10m0s --wait
sleep 10m
gsutil mb -l us-central1 gs://$PROJECT-kubernetes-manifests
sleep 10
gsutil versioning set on gs://$PROJECT-kubernetes-manifests