# Use a base Python image
FROM python:3

# Set the working directory
WORKDIR /app

# Install dependencies to fetch packages
RUN apt-get update && apt-get install -y curl unzip

# Install chromedriver
RUN curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE | xargs -I {} wget -q -O /usr/local/bin/chromedriver https://chromedriver.storage.googleapis.com/{}/chromedriver_linux64.zip && unzip /usr/local/bin/chromedriver_linux64.zip && rm /usr/local/bin/chromedriver_linux64.zip && chmod +x /usr/local/bin/chromedriver

# Copy test files
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]