#!/bin/bash

# Generates a 5-ish minutes movie theatre style intro video

echo "#!/bin/bash" >> tmp.sh
echo " export PATH="$PATH:"/usr/local/bin/" >> tmp.sh
echo -n "editly --out trivia.mp4 --width 1920 --height 1080 --fps 30 --transition-name fade  " >> tmp.sh

ls -d slides/* | sort -R | tail -21 | while read FILE; do
    echo -n "$FILE " >> tmp.sh
done
/bin/bash tmp.sh
rm tmp.sh
