# Use a base seleniumbase image
FROM seleniumbase/seleniumbase

# Set the working directory
WORKDIR /app

# Copy test files
COPY . .

# Command to run when container starts
ENTRYPOINT ["pytest", "tests"]