# ==========================================================
# Stage 1: Build the Angular application
# ==========================================================
FROM node:20-alpine AS build
WORKDIR /app

# Copy package management files first to leverage Docker layer caching
COPY package*.json ./
RUN npm ci

# Copy the rest of your application source code
COPY . .

# Generate the production build artifacts
RUN npm run build -- --configuration=production

# ==========================================================
# Stage 2: Serve the application using Nginx
# ==========================================================
FROM nginx:alpine

# Copy the compiled static files from the build stage to Nginx's hosting directory
# NOTE: In Angular 17+, the output directory structure is dist/[project-name]/browser.
# The wildcard (*) below automatically handles your specific project folder name.
COPY --from=build /app/dist/*/browser /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx in the foreground so the Docker container stays active
CMD ["nginx", "-g", "daemon off;"]