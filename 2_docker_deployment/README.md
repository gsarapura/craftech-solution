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


## Frontend
- Node version: using latest stable - 22.13.1
- Optimised Docker image
```sh
# Build
IMAGE_NAME=craftech-frontend:latest
docker build -t $IMAGE_NAME -f docker/Dockerfile .
# Run
docker run -it --rm -p 80:80 $IMAGE_NAME sh
docker run --rm -p 80:80 $IMAGE_NAME
```

## Backend
- Python version: tried to use python 3.13 but when building it causes lots of dependncies issues. Instead, using 3.12
- Optimised Docker image
```sh
IMAGE_NAME=craftech-backend:latest
cd docker/
docker build -t $IMAGE_NAME -f Dockerfile .
# Run
docker run -it --rm -p 8000:8000 -e SQL_DATABASE=core $IMAGE_NAME sh
docker run -it --rm -p 8000:8000  $IMAGE_NAME sh
docker run --rm -p 8000:8000 -e SQL_DATABASE=core $IMAGE_NAME
docker run --rm $IMAGE_NAME
```