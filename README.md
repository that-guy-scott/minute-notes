# Minute-Notes

Minute-Notes is a project that provides tools for transcribing audio and video files into text. It includes scripts for transcribing using Google Cloud Speech-to-Text API and OpenAI's Whisper model.

*This is still a work in progress. The next stage is to make api calls to an LLM to convert the text into minutes. *

## Components

1. `translate-audio-gcloud.py`: A Python script that uses Google Cloud Speech-to-Text API to transcribe audio files.
2. `transcribe_video.sh`: A Bash script that extracts audio from video files, segments it, and transcribes using OpenAI's Whisper model.
3. `Dockerfile`: A Dockerfile to create a container with all necessary dependencies for running the transcription scripts.

## Prerequisites

- Docker
- Google Cloud account and credentials (for using `translate-audio-gcloud.py`)

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/minute-notes.git
   cd minute-notes
   ```

2. Build the Docker image:
   ```
   docker build -t minute-notes .
   ```

## Usage

### Transcribing with OpenAI's Whisper (recommended)

To transcribe a video file using the `transcribe_video.sh` script:

1. Place your video file in the same directory as the Dockerfile.
2. Run the following command:
   ```
   docker run -v $(pwd):/output minute-notes your_video_file.mp4
   ```
   Replace `your_video_file.mp4` with the name of your video file.

The script will:
- Extract audio from the video
- Split the audio into 30-second segments
- Transcribe each segment using Whisper
- Combine the transcriptions into a single file

The final transcription will be saved as `your_video_file_transcription.txt` in the same directory.

### Transcribing with Google Cloud Speech-to-Text API

To use the `translate-audio-gcloud.py` script:

1. Set up Google Cloud credentials:
   - Create a Google Cloud project
   - Enable the Speech-to-Text API
   - Create a service account and download the JSON key file
   - Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the path of your JSON key file

2. Install the required Python packages:
   ```
   pip install google-cloud-speech
   ```

3. Run the script:
   ```
   python translate-audio-gcloud.py --file path/to/your/audio/file.mp3
   ```

The script will transcribe the audio file and save the transcription as a text file with the same name as the input file, but with a `.txt` extension.

## Notes

- The `transcribe_video.sh` script uses the "medium" model of Whisper. You can modify this in the script if you want to use a different model.
- The Google Cloud script (`translate-audio-gcloud.py`) is set up for MP3 files with a sample rate of 16000 Hz. Adjust the `encoding` and `sample_rate_hertz` parameters if your audio files have different specifications.

## Contributing

Contributions to Minute-Notes are welcome! Please feel free to submit a Pull Request.

## License

MIT License

Copyright (c) 2024 Scott Angel 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
