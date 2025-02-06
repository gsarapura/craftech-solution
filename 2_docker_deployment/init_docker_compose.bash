#!/bin/bash
aws --region us-east-1 secretsmanager get-secret-value \
    --region us-east-1 \
    --secret-id test/rds \
    --query SecretString \
    --output text | jq -r 'to_entries | .[] | "\(.key)=\(.value)"' > .env
docker network create craftech_network
docker rm -f backend frontend
docker compose up -d
# Remove credentials
> .env