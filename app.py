from flask import Flask, request, render_template
import pytesseract
from PIL import Image
import cv2
import numpy as np
import base64
import re
import os
 
app = Flask(__name__)
 
@app.route('/')
def index():
    return render_template('index.html')
 
@app.route('/upload_webcam', methods=['POST'])
def upload_webcam():
    data_url = request.form['image_data']
    header, encoded = data_url.split(",", 1)
    binary_data = base64.b64decode(encoded)
 
    # Convert to OpenCV image
    img_array = np.frombuffer(binary_data, dtype=np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
 
    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
 
    # Convert OpenCV image to PIL Image for pytesseract
    pil_img = Image.fromarray(gray)
 
    # OCR with pytesseract
    result_string = pytesseract.image_to_string(pil_img)
 
    # Regex to find total and cash values
    total_match = re.search(r'Total\s+(\d+\.\d+)', result_string)
    cash_match = re.search(r'Cash\s+(\d+\.\d+)', result_string)
 
    total_amount = total_match.group(1) if total_match else "Not Found"
    cash_paid = cash_match.group(1) if cash_match else "Not Found"
 
    return render_template('index.html', result=result_string, total=total_amount, cash=cash_paid)
 
if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
 