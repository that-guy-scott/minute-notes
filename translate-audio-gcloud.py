import argparse
from google.cloud import speech_v1p1beta1 as speech
import io
import os

def transcribe_audio(file_path):
    client = speech.SpeechClient()

    with io.open(file_path, "rb") as audio_file:
        content = audio_file.read()

    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.MP3,
        sample_rate_hertz=16000,
        language_code="en-US",
    )

    response = client.recognize(config=config, audio=audio)

    # Construct the output file path by changing the extension to .txt
    base_name = os.path.splitext(file_path)[0]
    output_file_path = f"{base_name}.txt"

    # Write the transcript to the output file
    with open(output_file_path, "w") as output_file:
        for result in response.results:
            output_file.write(result.alternatives[0].transcript + "\n")

    print(f"Transcription saved to {output_file_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Transcribe an audio file.")
    parser.add_argument("--file", required=True, help="Path to the audio file.")
    args = parser.parse_args()

    transcribe_audio(args.file)
