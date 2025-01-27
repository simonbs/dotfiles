#!/bin/bash

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
  echo "yt-dlp is not installed. Install it first."
  exit 1
fi

# Function to display usage
usage() {
  echo "Usage: $(basename "$0") <URL>"
  echo
  echo "Description:"
  echo "  Downloads the best available MP4 video using yt-dlp."
  echo
  echo "Examples:"
  echo "  $(basename "$0") https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  exit 1
}

# Check if URL is provided
if [ $# -eq 0 ]; then
  usage
fi

URL="$1"

yt-dlp -f "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]" \
  --merge-output-format mp4 \
  -o "%(title)s.%(ext)s" \
  --cookies-from-browser chrome "$1"
