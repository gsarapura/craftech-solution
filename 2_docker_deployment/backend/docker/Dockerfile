FROM python:3.11-alpine3.21 AS build

RUN apk upgrade --no-cache && \
    apk add --no-cache build-base libpq libpq-dev

COPY ./requirements.txt ./

RUN pip install -r requirements.txt

FROM python:3.11-alpine3.21

# Set environment variables
ENV NON_ROOT_USER=craft-user
ENV NON_ROOT_USER_FOLDER=craft-backend
ENV WORKING_FOLDER=/home/${NON_ROOT_USER}/${NON_ROOT_USER_FOLDER}

RUN apk upgrade --no-cache && \
    apk add --no-cache libpq && \
    adduser -D ${NON_ROOT_USER}

# Set user and working directory
USER $NON_ROOT_USER
WORKDIR $WORKING_FOLDER

COPY --from=build /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --chown=${NON_ROOT_USER}:${NON_ROOT_USER} ./ ./
RUN mv .env.postgres .env && chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]