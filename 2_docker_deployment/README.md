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
- Node version: using latest stable
```sh
# Build
IMAGE_NAME=craftech-frontend:latest
docker build -t $IMAGE_NAME -f docker/Dockerfile .
```