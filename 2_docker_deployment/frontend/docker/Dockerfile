# Using latest stable node version 
FROM node:22.13.1-alpine3.21 AS build
RUN mkdir -p /app
WORKDIR /app
RUN apk upgrade --no-cache
COPY ./ ./
RUN npm install && npm run build

# Use a lightweight web server to serve the built files
FROM nginxinc/nginx-unprivileged:alpine3.20-slim
# Copy the custom Nginx configuration
COPY docker/ngnix.conf /etc/nginx/conf.d/default.conf
# Copy the built files from the build stage to the nginx directory
COPY --from=build /app/build/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
