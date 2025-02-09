### STAGE 1: Build ###
FROM node:lts-alpine AS build
WORKDIR /usr/src/app

FROM nginx:1.17.1-alpine
COPY ../nginx.conf /etc/nginx/nginx.conf

RUN echo "@@@@@@@@@@@@@@"
RUN echo "@@@@@@@@@@@@@@"
RUN echo "@@@@@@@@@@@@@@"
RUN echo "@@@@@@@@@@@@@@"

COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN touch build_timestamp   
RUN npm run build

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
COPY ../nginx.conf /etc/nginx/nginx.conf
# COPY --from=build /usr/src/app/dist/banking-portal /usr/share/nginx/html
COPY --chown=nginx:nginx --from=build /usr/src/app/dist/banking-portal /usr/share/nginx/html 


# Adjust permissions for OpenShift
RUN chgrp -R 0 /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R g+rw /var/cache/nginx /var/run /var/log/nginx

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
