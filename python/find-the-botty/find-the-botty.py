print("Initialising...\n")

import os # file system
from tqdm import tqdm # progress bar
import speech_recognition as sr
from pydub import AudioSegment

# some file system constants
STORAGE_DIR = os.path.join("/", "Volumes", "old-data", "Jake's Stuff", "NSTAAF")
DATA_DIR = STORAGE_DIR
EXPORTS_DIR = os.path.join(STORAGE_DIR, "export")
TRANSCRIPTION_DIR = os.path.join(STORAGE_DIR, "transcribed")

# convert mp3 files to wav files
print("Starting file conversions...\n")
for input_file in tqdm(os.listdir(DATA_DIR)):
    filename, ext = os.path.splitext(input_file)
    if ext != ".mp3":
    	continue
    input_path = os.path.join(DATA_DIR, input_file)
    export_path = os.path.join(EXPORTS_DIR, filename + ".wav")
    if os.path.exists(export_path):
    	continue
    sound = AudioSegment.from_mp3(input_path)
    sound.export(export_path, format="wav")

# use the audio file as the audio source
# r = sr.Recognizer()
# with sr.AudioFile("test_trimmed.wav") as source:
    # audio = r.record(source)  # read the entire audio file
# try:
    # transcription = r.recognize_sphinx(audio)
    # print(transcription)
# except sr.UnknownValueError:
    # print("Sphinx could not understand audio")
# except sr.RequestError as e:
    # print("Sphinx error; {0}".format(e))

print("Transcribing audio files...\n")
for audio_file in tqdm(sorted(os.listdir(EXPORTS_DIR))):
    filename, ext = os.path.splitext(audio_file)
    if ext != ".wav":
    	continue
    audio_file_path = os.path.join(EXPORTS_DIR, audio_file)
    transcription_file_path = os.path.join(TRANSCRIPTION_DIR, filename + ".txt")
    if os.path.exists(transcription_file_path):
    	continue
    r = sr.Recognizer()
    with sr.AudioFile(audio_file_path) as source:
    	audio = r.record(source)  # read the entire audio file
    transcription = r.recognize_sphinx(audio)
    with open(transcription_file_path, "w") as transcription_file:
        transcription_file.write(transcription)

# Different speech recognition:
# Each Recognizer instance has seven methods for recognizing speech from an audio source using various APIs. These are:
    # recognize_bing(): Microsoft Bing Speech
    # recognize_google(): Google Web Speech API
    # recognize_google_cloud(): Google Cloud Speech - requires installation of the google-cloud-speech package
    # recognize_houndify(): Houndify by SoundHound
    # recognize_ibm(): IBM Speech to Text
    # recognize_sphinx(): CMU Sphinx - requires installing PocketSphinx
    # recognize_wit(): Wit.ai
# Of the seven, only recognize_sphinx() works offline with the CMU Sphinx engine. The other six all require an internet connection.
# A full discussion of the features and benefits of each API is beyond the scope of this tutorial. Since SpeechRecognition ships with a default API key for the Google Web Speech API, you can get started with it right away. For this reason, we’ll use the Web Speech API in this guide. The other six APIs all require authentication with either an API key or a username/password combination. For more information, consult the SpeechRecognition docs.
