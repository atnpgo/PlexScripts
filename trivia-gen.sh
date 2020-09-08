#!/bin/bash

#####################################################################################################
#                                                                                                   #
# Generates a video in the style of a movie theatre style intro video                               #
# The first argument is the desired length of the video in seconds (defaults to 600 or 10 minutes)  #
# This time will not be exact since the transition time is not taken into account                   #
#                                                                                                   #
#####################################################################################################


PATH="$PATH:"/usr/local/bin/
TOTAL_LEN=$1
TOTAL_LEN=${TOTAL_LEN:-600}
COMMAND="editly --out trivia.mp4 --width 1920 --height 1080 --fps 30 --transition-name fade --audio-file-path out.mp3"
SHUFFLED_FILES=(slides/*)
LEN=0
for ((INDEX = ${#SHUFFLED_FILES[@]} - 1; INDEX > 0; INDEX--)); do
    RAND=$((RANDOM % (INDEX + 1)))
    if ((RAND != INDEX)); then
        TEMP=${SHUFFLED_FILES[INDEX]}
        SHUFFLED_FILES[INDEX]=${SHUFFLED_FILES[RAND]}
        SHUFFLED_FILES[RAND]=$TEMP
    fi
done
ffmpeg -hide_banner -loglevel error  -y -f lavfi -i anullsrc=r=44100:cl=mono -t "00:00:01.55" -q:a 9 -acodec libmp3lame pad.mp3
FILES=()
for ((i = 0; i < TOTAL_LEN; i = i + LEN)); do
    FILE=${SHUFFLED_FILES[0]}
    SHUFFLED_FILES=("${SHUFFLED_FILES[@]:1}")
    LEN=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILE")
    LEN=${LEN%.*}
    NEEDS_AUDIO=$(ffprobe -v error -of flat=s_ -select_streams 1 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$FILE")
    FILES+=("$FILE.mp3")
    FILES+=("pad.mp3")
    if [ -z "$NEEDS_AUDIO" ]; then
        ffmpeg -hide_banner -loglevel error  -y -f lavfi -i anullsrc=r=44100:cl=mono -t "$(ffprobe -sexagesimal -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILE")" -q:a 9 -acodec libmp3lame "$FILE.mp3"
    else
        ffmpeg -hide_banner -loglevel error -y -i "$FILE" "$FILE.mp3"
    fi
    COMMAND+=" \"$FILE\""
done
AUDIO_COMMAND="ffmpeg -y -hide_banner -loglevel error"
for FILE in "${FILES[@]}"; do
    AUDIO_COMMAND+=" -i \"$FILE\""
done
FILTERS=""
OLD_FILTER="0"
INDEX=1
COUNT=${#FILES[@]}
while [ $INDEX -lt  "$COUNT" ]; do
    NEXT_FILTER=$(printf "a%02d" $INDEX)
    FILTERS+="[$OLD_FILTER][$INDEX]acrossfade=d=1:c1=tri:c2=tri[$NEXT_FILTER];"
    ((INDEX++))
    OLD_FILTER="$NEXT_FILTER"
done
AUDIO_COMMAND+=" -vn -filter_complex \"${FILTERS:0:$((${#FILTERS} - ${#OLD_FILTER} - 3))}\" out.mp3"
eval "$AUDIO_COMMAND"
for FILE in "${FILES[@]}"; do
    rm "$FILE"
done
eval "$COMMAND"
rm out.mp3
