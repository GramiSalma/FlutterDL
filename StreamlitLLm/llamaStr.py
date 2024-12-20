import streamlit as st
import requests

# URL de votre API Flask
API_URL = "http://127.0.0.1:5000/ask"

# Titre de l'application
st.title("Interface de Questions avec Ollama")

# Champ de saisie pour la question
question = st.text_input("Entrez votre question :", placeholder="C'est quoi une pomme ?")

# Bouton pour soumettre la question
if st.button("Poser la question"):
    if question.strip():
        # Envoyer la requête POST à l'API Flask
        try:
            response = requests.post(API_URL, json={"question": question})
            if response.status_code == 200:
                # Afficher la réponse du modèle
                st.success(f"Réponse : {response.json().get('response', 'Aucune réponse obtenue.')}")
            else:
                st.error(f"Erreur {response.status_code} : {response.json().get('error', 'Problème inconnu.')}")
        except Exception as e:
            st.error(f"Une erreur s'est produite : {e}")
    else:
        st.warning("Veuillez entrer une question avant de soumettre.")

