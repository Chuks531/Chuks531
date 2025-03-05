from flask import Flask, request, jsonify
from flask_cors import CORS
import openai
import speech_recognition as sr
from gtts import gTTS
import os

app = Flask(__name__)
CORS(app)  # Allow frontend access

# Load OpenAI API key from environment variable
openai.api_key = os.getenv("OPENAI_API_KEY")


@app.route("/speech-to-text", methods=["POST"])
def speech_to_text():
    """Converts audio to text using SpeechRecognition."""
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    recognizer = sr.Recognizer()

    with sr.AudioFile(file) as source:
        audio = recognizer.record(source)

    try:
        text = recognizer.recognize_google(audio)
        return jsonify({"transcript": text})
    except sr.UnknownValueError:
        return jsonify({"error": "Could not understand audio"}), 400
    except sr.RequestError:
        return jsonify({"error": "API request failed"}), 500


@app.route("/translate", methods=["POST"])
def translate_text():
    """Uses OpenAI API to translate text."""
    data = request.json
    text = data.get("text")
    target_lang = data.get("targetLanguage", "en")  # Set to English

    if not text:
        return jsonify({"error": "Missing text"}), 400

    prompt = f"Translate this text to {target_lang}: {text}"
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "system", "content": prompt}]
    )

    translated_text = response["choices"][0]["message"]["content"].strip()
    return jsonify({"translation": translated_text})


@app.route("/text-to-speech", methods=["POST"])
def text_to_speech():
    """Converts translated text to speech using gTTS."""
    data = request.json
    text = data.get("text")
    lang = data.get("lang", "en")  # Default to English

    if not text:
        return jsonify({"error": "No text provided"}), 400

    tts = gTTS(text=text, lang=lang)
    audio_path = "static/audio/output.mp3"
    tts.save(audio_path)

    return jsonify({"audio_url": audio_path})


if __name__ == "__main__":
    app.run(debug=True)
