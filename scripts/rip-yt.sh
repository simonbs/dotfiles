#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <URL>"
  exit 1
fi

yt-dlp -f "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]" \
  --merge-output-format mp4 \
  -o "%(title)s.%(ext)s" \
  --cookies-from-browser chrome "$1"
