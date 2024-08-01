# Use a base image
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y terraform ansible

# Command to run when container starts
ENTRYPOINT ["terraform", "--help"]