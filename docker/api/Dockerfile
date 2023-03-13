# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory to /app
WORKDIR /app

# Copy the code and setup.py file into the container at /app
COPY python/ /app

# Install any needed packages using setup.py
RUN python setup.py install

# Expose the port that the application will run on
EXPOSE 80

# Define the command to run the application when the container starts
CMD ["uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "5000"]
