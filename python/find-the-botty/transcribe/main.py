import os
import sys

import speech_recognition as sr
import pydub


def mp3_to_wav(f: str):
    sound = pydub.AudioSegment.from_mp3(f)
    fb, _ = os.path.splitext(f)
    f2 = fb + ".wav"
    sound.export(f2, format="wav")
    return sound


def transcribe(f: str):
    fb, e = os.path.splitext(f)
    if e != ".wav":
        raise ValueError("File must be wav")
    f2 = fb + ".txt"

    r = sr.Recognizer()
    with sr.AudioFile(f) as src:
        audio = r.record(src)
        transcription = r.recognize_sphinx(audio)
        with open(f2, "w") as fptr:
            fptr.write(transcription)

    return transcription


if __name__ == "__main__":
    f = sys.argv[1]
    fb, e = os.path.splitext(f)
    if e != ".wav":
        mp3_to_wav(f)
        f = fb + ".wav"
    transcribe(f)
