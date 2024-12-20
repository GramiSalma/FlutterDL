from fastapi import FastAPI, UploadFile, File
from tensorflow.keras.models import load_model
#Python Imaging Library  for reading images
from PIL import Image
import numpy as np
#traiter les fichiers en mémoire sans avoir besoin de les enregistrer
from io import BytesIO

app = FastAPI()



# Charger le modèle
model = load_model('cnnModel.h5')

# Fonction pour prédire une image
def predict_image(image):
    img = image.resize((224, 224))
    img_array = np.array(img)  # Pas de normalisation explicite
    img_array = np.expand_dims(img_array, axis=0)
    predictions = model.predict(img_array)
    return predictions

@app.post("/FastApi")
async def predict(file: UploadFile = File(...)):
    img = Image.open(BytesIO(await file.read()))
    predictions = predict_image(img)
    class_names = np.array(['apple','banana','beetroot','bell pepper','cabbage','capsicum','carrot',
 'cauliflower','chilli pepper','corn','cucumber','eggplant','garlic',
 'ginger','grapes','jalepeno','kiwi','lemon','lettuce','mango','onion',
 'orange','paprika','pear','peas','pineapple','pomegranate','potato',
 'raddish','soy beans','spinach','sweetcorn','sweetpotato','tomato',
 'turnip','watermelon'])  # Remplacer par tes classes
    predicted_class = class_names[np.argmax(predictions)]
    
    return {"prediction": predicted_class}


# uvicorn FastApiFruits:app --reload

# curl -X POST -F "file=@C:/Users/salma/OneDrive/Bureau/imagesTest/carrot.jpg" http://127.0.0.1:8000/FastApi   