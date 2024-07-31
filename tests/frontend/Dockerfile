# Use a base Python image
# FROM python:3
FROM seleniumbase/seleniumbase

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Install dependencies
# RUN pip install -r requirements.txt

# Install ChromeDriver
# RUN apt-get update && apt-get install -y wget unzip xvfb
# RUN wget https://storage.googleapis.com/chrome-for-testing-public/127.0.6533.88/linux64/chromedriver-linux64.zip
# RUN unzip chromedriver-linux64.zip 
# RUN ls chromedriver-linux64/
# RUN cp chromedriver-linux64/chromedriver /usr/local/bin/


# Command to run when container starts
# ENTRYPOINT ["pytest", "tests", "--uc", "--xvfb"]
ENTRYPOINT ["pytest", "tests"]