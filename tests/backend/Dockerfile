# Use a base Python image
FROM python:3

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

RUN pwd
RUN ls

# Install dependencies
RUN pip install -r requirements.txt