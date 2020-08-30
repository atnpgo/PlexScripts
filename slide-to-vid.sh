#!/bin/bash

# Merges two images passed as arguments into a single video slide

ffmpeg -y -hide_banner -loglevel panic -i "$1" -vcodec libx264 -pix_fmt yuv420p -vf 'zoompan=d=15/1:s=1920x1080:fps=1/1,framerate=30:interp_start=0:interp_end=255:scene=100' "$1.mp4"

if ! [ -x "$(command -v trash)" ]; then
    rm "$1"
else
    trash "$1"
fi
