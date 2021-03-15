#!/bin/bash
if [[ -z $1 ]]; then
  echo "Usage: $0 <URL to stream video from>"
  exit
fi
output_name="video.mp4"
if [[ ! -z $2 ]]; then
  output_name=$2
fi
ffmpeg -i $1 -c copy -bsf:a aac_adtstoasc $output_name
