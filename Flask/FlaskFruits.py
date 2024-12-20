from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np

app = Flask(__name__)

# Charger le modèle
model = load_model('cnnModel.h5')

# Fonction pour prédire une image
def predict_image(image):
    img = image.resize((224, 224))
    img_array = np.array(img)  # Pas de normalisation explicite
    img_array = np.expand_dims(img_array, axis=0)
    predictions = model.predict(img_array)
    return predictions

@app.route('/Flask', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})
    
    img = Image.open(file)
    predictions = predict_image(img)
    class_names = np.array(['apple','banana','beetroot','bell pepper','cabbage','capsicum','carrot',
 'cauliflower','chilli pepper','corn','cucumber','eggplant','garlic',
 'ginger','grapes','jalepeno','kiwi','lemon','lettuce','mango','onion',
 'orange','paprika','pear','peas','pineapple','pomegranate','potato',
 'raddish','soy beans','spinach','sweetcorn','sweetpotato','tomato',
 'turnip','watermelon'])  # Remplacer par tes classes
    predicted_class = class_names[np.argmax(predictions)]
    
    return jsonify({'prediction': predicted_class})

if __name__ == "__main__":
    app.run(debug=True)

    
#curl -X POST -F "file=@C:/Users/salma/OneDrive/Bureau/imagesTest/ton_image.jpg" http://127.0.0.1:5000/Flask
