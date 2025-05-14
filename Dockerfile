FROM python:3.11-slim
 
# Install tesseract and other dependencies
RUN apt-get update && apt-get install -y tesseract-ocr libglib2.0-0 libsm6 libxext6 libxrender-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Set workdir
WORKDIR /app
 
# Copy app code
COPY . .
 
# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
 
# Start app
CMD ["gunicorn", "app:app"]