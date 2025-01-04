#!/bin/bash

# Input: Environment name (case-insensitive)
ENV_NAME=$1

# Convert to uppercase for environment variable lookup
ENV_UPPER=$(echo "$ENV_NAME" | tr '[:lower:]' '[:upper:]')

# Determine the cluster based on the environment
case "$ENV_UPPER" in
  DEVELOPMENT|INTEGRATION|UAT)
    CLUSTER="hors-prod"
    ;;
  PREPRODUCTION|PRODUCTION)
    CLUSTER="prod"
    ;;
  *)
    echo "Error: Unknown environment name '$ENV_NAME'."
    exit 1
    ;;
esac

# Construct ARGOCD_AUTH_TOKEN using GitLab CI variable
ARGOCD_AUTH_TOKEN_VAR="ARGOCD_${ENV_UPPER}_TOKEN"
ARGOCD_AUTH_TOKEN="${!ARGOCD_AUTH_TOKEN_VAR}"

if [ -z "$ARGOCD_AUTH_TOKEN" ]; then
  echo "Error: Environment variable '$ARGOCD_AUTH_TOKEN_VAR' is not set."
  exit 1
fi

# Construct ARGOCD_SERVER by replacing 'api' with 'cd' in the cluster endpoint
ARGOCD_SERVER="cd.$CLUSTER.gca"

# Export variables
export ARGOCD_AUTH_TOKEN
export ARGOCD_SERVER

# Output for verification (optional)
echo "Environment: $ENV_NAME"
echo "ARGOCD_AUTH_TOKEN is set."
echo "ARGOCD_SERVER: $ARGOCD_SERVER"
