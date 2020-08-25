#!/bin/bash

# Generates a 5 minutes movie theatre style intro video

echo "#!/bin/bash" >> tmp.sh
echo -n "ffmpeg-concat -d 1000 -o trivia.mp4 -c 1 " >> tmp.sh


ls -d slides/* | sort -R | tail -22 | while read FILE; do
    echo -n "$FILE " >> tmp.sh
done

/bin/bash tmp.sh
rm tmp.sh

#ffmpeg -y -hide_banner -loglevel panic -f concat -i tmp.txt -vcodec libx264 -pix_fmt yuv420p -filter_complex "xfade=offset=4.5:duration=1" trivia.mp4
#ffmpeg -y -hide_banner -loglevel panic -f concat -i tmp.txt -vcodec libx264 -pix_fmt yuv420p -vf 'zoompan=d=15/1:s=1920x1080:fps=1/1,framerate=30:interp_start=0:interp_end=255:scene=100' trivia.mp4


