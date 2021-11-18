#!/bin/bash

DEMO_NAMESPACE="demo-rm"

JENKINS_HELM_CHART_VERSION="3.8.6"
ARTIFACTORY_HELM_CHART_VERSION="107.27.9"
ARGOCD_HELM_CHART_VERSION="3.26.3"

echo "#### Prep environment for Demo ####"

kubectl create ns $DEMO_NAMESPACE

echo "## Add JFrog Helm repo..."
helm repo add jfrog https://charts.jfrog.io
echo "## Add Jenkins Helm repo..."
helm repo add jenkins https://charts.jenkins.io
echo "## Add ArgoCD Helm repo..."
helm repo add argo https://argoproj.github.io/argo-helm
echo "## Helm repo update..."
helm repo update

# Jenkins server install
echo "## Install Jenkins server..."
helm install jenkins jenkins/jenkins --version="$JENKINS_HELM_CHART_VERSION" -n $DEMO_NAMESPACE
echo "## Get admin password..."
#kubectl get secret/jenkins -n $DEMO_NAMESPACE -o jsonpath="{.data.password}" | base64 -d

# Artifctory server install
echo "## Artifactory server install..."
helm install artifactory jfrog/artifactory --version="$ARTIFACTORY_HELM_CHART_VERSION" -n $DEMO_NAMESPACE

# ArgoCD server install
echo "## ArgoCD server install..."
helm install artifactory argo/argo-cd --version="$ARGOCD_HELM_CHART_VERSION" -n $DEMO_NAMESPACE
echo "## Get admin creds for ArgoCD..."
#kubectl -n $DEMO_NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

echo "## Wait for 5 sec... ##"
sleep 5

kubectl get all -n $DEMO_NAMESPACE
