print("Initialising...\n")
import time
import os # file system
from tqdm import tqdm # progress bar
import speech_recognition as sr
from pydub import AudioSegment

# some file system constants
DATA_DIR = "data"
EXPORTS_DIR = os.path.join(DATA_DIR, "export")
TRANSCRIPTION_DIR = os.path.join(DATA_DIR, "transcribed")

# convert mp3 files to wav files
print("Starting file conversions...\n")
for input_file in tqdm(os.listdir(DATA_DIR)):
    filename, ext = os.path.splitext(input_file)
    if ext != ".mp3":
    	continue
    input_path = os.path.join(DATA_DIR, input_file)
    export_path = os.path.join(EXPORTS_DIR, filename + ".wav")
    # sound = AudioSegment.from_mp3(input_path)
    # sound.export(export_path, format="wav")

# transcribe audio file
# AUDIO_FILE = "data/export/transcript.wav"
# r = sr.Recognizer()
# with sr.AudioFile(AUDIO_FILE) as source:
# audio = r.record(source)  # read the entire audio file
# transcribed = r.recognize_google(audio)

# use the audio file as the audio source
print("Transcribing audio files...\n")
for audio_file in tqdm(os.listdir(EXPORTS_DIR)):
    filename, ext = os.path.splitext(audio_file)
    if ext != ".wav":
    	continue
    audio_file_path = os.path.join(EXPORTS_DIR, audio_file)
    transcription_file_path = os.path.join(TRANSCRIPTION_DIR, filename + ".txt")
    # r = sr.Recognizer()
    # with sr.AudioFile(audio_file_path) as source:
    	# audio = r.record(source)  # read the entire audio file
    	# transcription = r.recognize_google(audio)
    	# with open(transcription_file_path, "w") as transcription_file:
    	    # transcription_file.write(transcription)
