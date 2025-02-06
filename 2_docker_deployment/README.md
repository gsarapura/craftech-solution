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

# Alternative
docker run -it --rm -p 8000:8000 --network=$NETWORK_NAME -e SQL_DATABASE="core" -e SQL_USER="user" \
            -e SQL_PASSWORD="password" -e SQL_HOST="db" -e SQL_PORT=5432 $IMAGE_NAME sh

cd frontend/
# Build
IMAGE_NAME=craftech-frontend:latest
docker build -t $IMAGE_NAME -f docker/Dockerfile .
# Run
docker run -it --rm --network=$NETWORK_NAME -p 3000:80 $IMAGE_NAME sh
# Access browser at http://www.localhost:3000

# Alternative
docker run --rm --network=$NETWORK_NAME -p 3000:80 $IMAGE_NAME
```

# Docker Compose
