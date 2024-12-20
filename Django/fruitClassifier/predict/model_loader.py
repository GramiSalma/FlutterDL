import tensorflow as tf
from tensorflow.keras.models import load_model

# Chemin vers le fichier du modèle
MODEL_PATH = 'model/cnnModel.h5'

# Charger le modèle une seule fois au démarrage du serveur
def load_cnn_model():
    model = load_model(MODEL_PATH)
    print("✅ Modèle chargé avec succès !")
    return model

# Charger le modèle au démarrage
model = load_cnn_model()
