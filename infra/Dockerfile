# Use a base image
FROM archlinux:latest

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
RUN pacman -Sy 
RUN pacman -S --needed --noconfirm python-pip terraform ansible
RUN python -m pip install boto3 botocore