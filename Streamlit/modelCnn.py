import streamlit as st
import tensorflow as tf
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np

# Charger le modèle
model = load_model('cnnModel.h5')

# Fonction pour prédire une image
def predict_image(image):
    img = image.resize((224, 224))  # Redimensionner l'image
    img_array = np.array(img)  # Pas de normalisation explicite
    img_array = np.expand_dims(img_array, axis=0)  # Ajouter dimension batch
    predictions = model.predict(img_array)
    return predictions

st.title('Prédiction de fruits')

# Interface utilisateur
uploaded_file = st.file_uploader("Choisir une image", type=["jpg", "png", "jpeg"])

if uploaded_file is not None:
    img = Image.open(uploaded_file)
    st.image(img, caption='Image téléchargée', use_column_width=True)
    
    # Prédiction
    predictions = predict_image(img)
    class_names = np.array(['apple','banana','beetroot','bell pepper','cabbage','capsicum','carrot',
 'cauliflower','chilli pepper','corn','cucumber','eggplant','garlic',
 'ginger','grapes','jalepeno','kiwi','lemon','lettuce','mango','onion',
 'orange','paprika','pear','peas','pineapple','pomegranate','potato',
 'raddish','soy beans','spinach','sweetcorn','sweetpotato','tomato',
 'turnip','watermelon'])  
    predicted_class = class_names[np.argmax(predictions)]
    
    st.write(f"Prédiction : {predicted_class}")
