import os
import numpy as np
from django.shortcuts import render
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image

# Chemin vers le modèle
MODEL_PATH = 'model/cnnModel.h5'

# Charger le modèle une seule fois au démarrage du serveur
def load_cnn_model():
    model = load_model(MODEL_PATH)
    print("✅ Modèle chargé avec succès !")
    return model

# Charger le modèle au démarrage
model = load_cnn_model()

# Liste des classes (modifie en fonction de tes classes)
class_names = [
    'apple', 'banana', 'beetroot', 'bell pepper', 'cabbage', 'capsicum', 'carrot',
    'cauliflower', 'chilli pepper', 'corn', 'cucumber', 'eggplant', 'garlic', 'ginger',
    'grapes', 'jalapeno', 'kiwi', 'lemon', 'lettuce', 'mango', 'onion', 'orange', 
    'paprika', 'pear', 'peas', 'pineapple', 'pomegranate', 'potato', 'radish', 
    'soy beans', 'spinach', 'sweetcorn', 'sweetpotato', 'tomato', 'turnip', 'watermelon'
]

#     python manage.py runserver

# Vue principale pour afficher la page d'accueil
def index(request):
    prediction = None  # Initialisation de la variable prediction
    if request.method == 'POST' and request.FILES.get('image'):
        img_file = request.FILES['image']
        img_path = f"temp_{img_file.name}"

        with open(img_path, 'wb+') as f:
            for chunk in img_file.chunks():
                f.write(chunk)

        try:
            # Charger et prétraiter l'image
            img = image.load_img(img_path, target_size=(224, 224))  # Redimensionner l'image
            img_array = image.img_to_array(img)  # Convertir en tableau NumPy
            img_array = np.expand_dims(img_array, axis=0)  # Ajouter une dimension batch

            # Prédiction avec le modèle
            predictions = model.predict(img_array)
            predicted_index = np.argmax(predictions, axis=1)[0]
            

            # Obtenir la classe prédite
            predicted_class = class_names[predicted_index]

            # Supprimer l'image temporaire
            os.remove(img_path)

            prediction = {
                'predicted_class': predicted_class,

            }

        except Exception as e:
            prediction = {'error': str(e)}

    return render(request, 'upload.html', {'prediction': prediction})
