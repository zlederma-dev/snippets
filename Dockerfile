# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package-lock.json package.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build

# Serve stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
