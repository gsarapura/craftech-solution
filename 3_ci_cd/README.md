# CI/CD
## Prueba 3:
CI/CD Dockerizar un nginx con el index.html default. Elaborar un pipeline que ante cada cambio realizado sobre el index.html buildee
la nueva imagen y la actualize en la plataforma elegida. (docker-compose, swarm, kuberenetes, etc.) 
Para la creacion del CI/CD se puede utilizar cualquier plataforma (CircleCI, Gitlab, Github, Bitbucket.)

## Description 
- Using latest stable https://nginx.org/en/download.html: currently 1.27.3
- 
```sh
# Locally
IMAGE_TAG_NAME="gsarapura/craftech-technical-solution:3_ci_cd"
docker build -t $IMAGE_TAG_NAME .
docker run --rm -p 8080:80 $IMAGE_TAG_NAME
```