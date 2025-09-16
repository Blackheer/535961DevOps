# Use an official Python runtime as a parent image
FROM python:3.12-slim-bookworm

# Set work directory in the container
WORKDIR /app

# Copy requirements and install Python dependencies
COPY /content/requirements.txt /app/
RUN pip install -r requirements.txt

# Copying the project files into the container
COPY /content/. /app/

# Expose webserver port
EXPOSE 5000

# Run the webserver
CMD ["flask", "run", "-h", "0.0.0.0", "-p", "5000"]
