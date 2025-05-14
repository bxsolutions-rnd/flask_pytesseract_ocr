# Use a Python base image
FROM python:3.11-slim
 
# Install Tesseract and other dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*
 
# Set working directory
WORKDIR /app
 
# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
 
# Copy all files
COPY . .
 
# Expose port (Render uses 10000 internally; 0.0.0.0 is required)
EXPOSE 10000
 
# Run app with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]
 