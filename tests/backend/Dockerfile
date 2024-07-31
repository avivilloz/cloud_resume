# Use a base Python image
FROM python:3

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt ./

# Install dependencies
RUN pip install -r requirements.txt   

# Copy the project code
COPY tests ./

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]