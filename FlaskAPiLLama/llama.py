from flask import Flask, request, jsonify
import subprocess
from flask_cors import CORS 
app = Flask(__name__)
#exécuter des commandes système
CORS(app)

@app.route('/ask', methods=['POST'])
def ask_model():
    data = request.json
    question = data.get('question', '')
    if not question:
        return jsonify({"error": "No question provided"}), 400

    # Exécuter Ollama dans le terminal et capturer la sortie
    result = subprocess.run(
        ["ollama", "run", "llama3.2", question],
        capture_output=True,
      # Forcer l'encodage UTF-8
        text=True,
        encoding="utf-8"  
    )
    return jsonify({"response": result.stdout}), 200, {'Content-Type': 'application/json; charset=utf-8'}
#  recevoir des connexions de n'importe quelle adresse IP 
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)




# curl -X POST http://127.0.0.1:5000/ask -H "Content-Type: application/json" -d "{\"question\": \"C est quoi une pomme  ?\"}"