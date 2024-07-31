# Use a base Python image
# FROM python:3
FROM selenium/standalone-chrome:latest

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]