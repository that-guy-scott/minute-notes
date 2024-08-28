#!/bin/bash

set -e

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Please provide an input .mp4 file"
    exit 1
fi

input_file="/output/$1"
audio_file="/output/${1%.*}.mp3"
segments_dir="/output/segments"
transcription_file="/output/${1%.*}_transcription.txt"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
fi

# Create segments directory
mkdir -p "$segments_dir"

# Extract audio
echo "Extracting audio from $input_file..."
ffmpeg -i "$input_file" -vn -acodec libmp3lame "$audio_file"

# Cut audio into 30-second segments
echo "Cutting audio into 30-second segments..."
ffmpeg -i "$audio_file" -f segment -segment_time 30 -c copy "$segments_dir/segment_%03d.mp3"

# Function to transcribe a single segment
transcribe_segment() {
    segment=$1
    output_file="${segment%.*}.json"
    whisper "$segment" --model medium --output_dir "$segments_dir" --output_format json --word_timestamps True
    mv "$segments_dir/$(basename "${segment%.*}").json" "$output_file"
    echo "Transcribed: $segment"
}

# Transcribe segments in parallel
echo "Transcribing segments... This may take a while."
echo "Started at $(date)"

export -f transcribe_segment
find "$segments_dir" -name "segment_*.mp3" | sort | parallel transcribe_segment

echo "Transcription complete at $(date)"

# Combine transcriptions
echo "Combining transcriptions..."
echo "" > "$transcription_file"
for json in $(find "$segments_dir" -name "*.json" | sort); do
    jq -r '.segments[] | .words[] | .word' "$json" | tr -d '\n' >> "$transcription_file"
    echo -e "\n--- End of segment ---\n" >> "$transcription_file"
done

# Clean up
rm -r "$segments_dir"
rm "$audio_file"

echo "Full transcription saved to $transcription_file"

# Display the first few lines of the transcription
echo "First few lines of the transcription:"
head -n 10 "$transcription_file"