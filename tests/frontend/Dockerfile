# Use a base Python image
FROM python:3

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Install ChromeDriver
RUN apt-get update && \
    apt-get install -y wget

RUN wget -O /usr/local/bin/chromedriver https://storage.googleapis.com/chrome-for-testing-public/127.0.6533.88/linux64/chromedriver-linux64.zip && \
    unzip /usr/local/bin/chromedriver -d /usr/local/bin && \
    rm /usr/local/bin/chromedriver.zip && \
    chmod +x /usr/local/bin/chromedriver

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]