# DOCKER DEPLOYMENT

## Task
Prueba 2 - Despliegue de una aplicación Django y React.js Elaborar
el deployment dockerizado de una aplicación en django (backend) con frontend
en React.js contenida en el repositorio. Es necesario desplegar todos los servicios
en un solo docker-compose.

Se deben entregar los Dockerfiles pertinentes para elaborar el despliegue y jus-
tificar la forma en la que elabora el deployment (supervisor, scripts, docker-
compose, kubernetes, etc)

Subir todo lo elaborado a un repositorio (github, gitlab, bitbucket, etc). En el
repositorio se debe incluir el código de la aplicación y un archivo README.md
con instrucciones detalladas para compilar y desplegar la aplicación, tanto en
una PC local como en la nube (AWS o GCP).

## Overview
This solution combines both the Frontend and Backend within a single `docker-compose.yaml` file. The database will be external to both services and will not be included in the `docker-compose.yaml`. Additionally, there will be two separate Docker Compose configurations: one for local development and another for the deployment service (EC2).

## Backend
* Python version: Attempted to use Python 3.13, but it caused several dependency issues. Instead, Python 3.11 is being used.
* Optimized Docker image:
  - Build stage: The first stage (build) installs dependencies, including `psycopg2-binary` due to dependencies issues from psycopg2.
  - Final stage: The second stage builds the actual runtime environment by copying over the installed dependencies from the build stage and setting up the app for production use.

## Frontend
* Node version: Using the latest stable version, `22.13.1`.
* Optimized Docker image: `frontend/docker/Dockerfile`
  - Build stage: The first stage installs dependencies, builds the React app, and prepares the static files.
  - Final stage: The second stage uses a lightweight Nginx server to serve the built static files, with a custom Nginx configuration to handle React routing.
* Nginx custom configuration: Configured to allow React to handle routing via `frontend/docker/nginx.conf`.

## Build Images:
```sh
$NETWORK_NAME=craftech_network
docker network create  $NETWORK_NAME

cd backend/
IMAGE_NAME=craftech-backend:latest
docker build -t $IMAGE_NAME -f docker/Dockerfile .
# Run
docker run --rm -p 8000:8000 --network=$NETWORK_NAME -e SQL_DATABASE="core" -e SQL_USER="user" \
            -e SQL_PASSWORD="password" -e SQL_HOST="db" -e SQL_PORT=5432 $IMAGE_NAME

# Alternatives
docker run -it --rm -p 8000:8000 --network=$NETWORK_NAME -e SQL_DATABASE="core" -e SQL_USER="user" \
            -e SQL_PASSWORD="password" -e SQL_HOST="db" -e SQL_PORT=5432 $IMAGE_NAME sh
docker run -it --rm -p 8000:8000 $IMAGE_NAME sh

cd frontend/
# Build
IMAGE_NAME=craftech-frontend:latest
docker build -t $IMAGE_NAME -f docker/Dockerfile .
# Run
docker run --rm --network=$NETWORK_NAME -p 3000:80 $IMAGE_NAME
# Access browser at http://www.localhost:3000

# Alternative
docker run -it --rm --network=$NETWORK_NAME -p 3000:80 $IMAGE_NAME sh
```

# Docker Compose
- Updated `backend/docker-compose.yaml`to use an external network that can communicate docker-compose containing frontend and backend

```sh
$NETWORK_NAME=craftech_network
docker network create  $NETWORK_NAME

# Local run
# Postgres DB
cd backend/
docker compose up --build

# Another terminal
cd 2_docker_deployment/
# Frontend/Backend. For backend create backend/.env as:
SQL_DATABASE=
SQL_USER=
SQL_PASSWORD=
SQL_HOST=
SQL_PORT=
cd ../
docker compose -f docker-compose-local.yaml up --build
# Access browser at http://www.localhost:3000
```

# Deploy to EC2
- Running Ubuntu, Docker has been installed following [official documentation](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).
- Installed [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- EC2 instance must have permission to retrieve secrets
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:REGION:ACCOUNT_ID:secret:NAME-*" 
    }
  ]
}

```
- The following steps are already automated by `.github/workflows/2_docker_deployment.yaml`:
```sh
$DOCKER_USERNAME="gsarapura"

cd frontend/
IMAGE_TAG_NAME="gsarapura/craftech-2-docker-deployment-frontend:latest"
docker build -t $IMAGE_TAG_NAME -f docker/Dockerfile .
docker login -u $USERNAME
docker push $IMAGE_TAG_NAME

cd backend/
IMAGE_TAG_NAME="gsarapura/craftech-2-docker-deployment-backend:latest"
docker build -t $IMAGE_TAG_NAME -f docker/Dockerfile .
docker push $IMAGE_TAG_NAME

# Also the load of the script and docker compose yaml into EC2 instance as the execution of the script in charge of setting up and running docker compose.
```
- In `init_docker_compose.bash`, docker compose is set up and started. Using AWS cli to retrieve credentials from Secret Manager as removing the content of .env file when docker compose is started.
- Getting CORS error in EC2 instance, but working locally. This error is caused by missing EC2 host in "CORS_ALLOWED_ORIGINS" list (`backend/core/setting.py`).
