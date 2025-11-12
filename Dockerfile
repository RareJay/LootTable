# Stage 1: Build Stage (Optional but good for static site generators or minification)
# For a simple HTML/CSS site, this stage might not be strictly necessary
# but it's a good pattern if you later add build steps (e.g., SASS compilation, JS minification).
# We'll use a minimal base for this example.
FROM alpine AS builder

# Set working directory
WORKDIR /app

# Copy your entire website source folder
# Assuming your website files are in a 'src' folder next to the Dockerfile
COPY src ./src

# If you had any build steps for your static site (e.g., converting SASS to CSS, minifying JS)
# you would add them here. For a plain HTML/CSS site, this is often empty.
# RUN npm install && npm run build # Example for a JS-based build step

# Stage 2: Production Stage (Serve with Nginx)
# Use a very small Nginx base image
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy a custom Nginx configuration file
# This file will tell Nginx where to find your website files.
# Make sure you create 'nginx.conf' in the same directory as your Dockerfile.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy your website's static files from the 'builder' stage
# Assuming the 'builder' stage output its files into /app/src, or directly /app
COPY --from=builder /app/src /usr/share/nginx/html

# Expose port 80, the default HTTP port Nginx listens on
EXPOSE 80

# The default command for the nginx:alpine image already runs Nginx,
# so we typically don't need a CMD instruction unless we want to override it.
# CMD ["nginx", "-g", "daemon off;"]