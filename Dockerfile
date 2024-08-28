# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    parallel \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Whisper
RUN pip3 install openai-whisper

# Set the working directory
WORKDIR /app

# Copy the transcription script into the container
COPY transcribe_video.sh /app/transcribe_video.sh

# Make the script executable
RUN chmod +x /app/transcribe_video.sh

# Set the entrypoint to our script
ENTRYPOINT ["/app/transcribe_video.sh"]