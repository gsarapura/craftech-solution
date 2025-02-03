# Using latest stable node version 
FROM node:22.13.1-alpine3.21 AS build
RUN mkdir -p /app
WORKDIR /app
RUN apk upgrade --no-cache
COPY ./ ./
RUN npm install && npm run build

# Use a lightweight web server to serve the built files
FROM nginx:alpine
# Set environment variables
ENV NON_ROOT_USER=craftech-user
ENV NON_ROOT_USER_FOLDER=craftech-frontend
ENV WORKING_FOLDER=/home/${NON_ROOT_USER}/${NON_ROOT_USER_FOLDER}

RUN apk upgrade --no-cache && \
    adduser -D "$NON_ROOT_USER"

# Set user and working directory
USER $NON_ROOT_USER
WORKDIR $WORKING_FOLDER

# Copy the custom Nginx configuration
COPY --chown=$NON_ROOT_USER:$NON_ROOT_USER docker/ngnix.conf /etc/nginx/conf.d/default.conf
# Copy the built files from the build stage to the nginx directory
COPY --from=build app/build/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
