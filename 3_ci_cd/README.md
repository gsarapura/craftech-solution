# CI/CD
## Prueba 3:
CI/CD Dockerizar un nginx con el index.html default. Elaborar un pipeline que ante cada cambio realizado sobre el index.html buildee
la nueva imagen y la actualize en la plataforma elegida. (docker-compose, swarm, kuberenetes, etc.) 
Para la creacion del CI/CD se puede utilizar cualquier plataforma (CircleCI, Gitlab, Github, Bitbucket.)

## Description 
* Using latest stable (https://nginx.org/en/download.html): `version 1.27.3`
* GitHub Action: `.github/workflows/3_ci_cd.yaml` 
    - Triggered by any changes to 3_ci_cd/index.html on main branch. Also allowed to run manually (`workflow_dispatch`).
    - Login to Dockerhub by using Personal Access Token, this one saved as secrete in GitHub Repository.
    - Building image and pushing into Dockerhub repository: https://hub.docker.com/repository/docker/gsarapura/craftech-technical-solution/general.

- Commands to run locally:
```sh
IMAGE_TAG_NAME="gsarapura/craftech-technical-solution:3_ci_cd"
docker build -t $IMAGE_TAG_NAME .
docker run --rm -p 8080:80 $IMAGE_TAG_NAME
# Go to http://www.localhost:8080
```