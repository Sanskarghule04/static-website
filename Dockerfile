# Use official nginx base image
FROM nginx:alpine

# Copy all website files to nginx html folder
COPY . /usr/share/nginx/html
