# Use a lightweight Python base image
FROM python:3.11-slim
 
# Avoid interactive prompts and install dependencies
ENV DEBIAN_FRONTEND=noninteractive
 
# Install system dependencies including Tesseract
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Set working directory
WORKDIR /app
 
# Copy Python dependencies
COPY requirements.txt .
 
# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt
 
# Copy the rest of your app
COPY . .
 
# Expose the desired port (5000 is typical unless changed)
EXPOSE 5000
 
# Run the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
 