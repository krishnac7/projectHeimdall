from flask import Flask, render_template, request, Response
import requests
import base64
import json
import os


app = Flask(__name__)

port = int(os.getenv('PORT', 8080))

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process-image', methods=['POST'])
def process_image():
    if 'image' not in request.files:
        return "No image provided", 400

    image = request.files['image'].read()
    query = request.form.get('query', '')
    base64_image = base64.b64encode(image).decode('utf-8')

    url = 'http://localhost:11434/api/generate'
    data = {
        "model": "llava",
        "prompt": query,
        "images": [base64_image]
    }
    
    response = requests.post(url, json=data, stream=True)

    def generate():
        for chunk in response.iter_content(chunk_size=1024):
            if chunk:
                chunk_text = chunk.decode('utf-8')
                try:
                    json_data = json.loads(chunk_text)
                    response_text = json_data.get('response', '')
                    if response_text:
                        yield f"{response_text}"
                except json.JSONDecodeError:
                    continue
    
    return Response(generate(), mimetype='text/event-stream')

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True,port=port)
