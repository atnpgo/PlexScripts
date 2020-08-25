#!/bin/bash

# Merges two images passed as arguments into a single video slide

echo "file '$1'" >>tmp.txt
echo "file '$1'" >>tmp.txt
echo "file '$2'" >>tmp.txt
ffmpeg -y -hide_banner -loglevel panic -f concat -i tmp.txt -vcodec libx264 -pix_fmt yuv420p -vf 'zoompan=d=5/1:s=1920x1080:fps=1/1,framerate=30:interp_start=0:interp_end=255:scene=100' "$1.mp4"

rm tmp.txt
trash "$1" "$2"
