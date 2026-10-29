# ---- Build ----
FROM node:22-alpine AS build

WORKDIR /app

ARG VITE_KEYCLOAK_URL=http://localhost:8082
ARG VITE_KEYCLOAK_REALM=idv-bursiyer
ARG VITE_KEYCLOAK_CLIENT=idv-bursiyer-frontend
ARG VITE_AUTH_ENABLED=true

ENV VITE_KEYCLOAK_URL=$VITE_KEYCLOAK_URL
ENV VITE_KEYCLOAK_REALM=$VITE_KEYCLOAK_REALM
ENV VITE_KEYCLOAK_CLIENT=$VITE_KEYCLOAK_CLIENT
ENV VITE_AUTH_ENABLED=$VITE_AUTH_ENABLED

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---- Run ----
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
