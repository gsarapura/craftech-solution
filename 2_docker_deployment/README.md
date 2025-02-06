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
The following solution will have in mind that both Frontend and Backend will be into one docker-compose.yaml. 
Database will be external to both of them, that is, DB won't be part of the docker-compose.yaml

## Backend
* Python version: tried to use python 3.13 but when building it causes lots of dependencies issues. Instead, using 3.11.
* Optimised Docker image:
    - Due to issues with psycopg2, psycopg2-binary had to be installed

## Frontend
- Node version: using latest stable - 22.13.1
- Optimised Docker image: `frontend/docker/Dockerfile`
- Ngnix custom config, so that React handles routing: `frontend/docker/ngnix.conf`

## Run locally:
```sh
cd backend/
IMAGE_NAME=craftech-backend:latest
# cd docker/
# docker build -t $IMAGE_NAME -f Dockerfile .
docker build -t $IMAGE_NAME -f docker/Dockerfile .
docker compose up # Run postgres DB
docker compose config # Check network name
# Run
NETWORK_NAME=""
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
docker network create craftech_network
echo "your-database-password" > ./secrets/sql_password.txt
echo "your-database-user" > ./secrets/sql_user.txt


# Local run
# Postgres DB
cd backend/
docker compose up --build
# Another terminal
# Frontend/Backend. For backend create .env as:
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

-
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
```