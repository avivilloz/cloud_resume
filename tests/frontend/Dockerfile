# Use a base Python image
# FROM python:3
FROM selenium/standalone-chrome:latest

# Install python and pip 
RUN apt-get update && apt-get install -y python python-pip

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]