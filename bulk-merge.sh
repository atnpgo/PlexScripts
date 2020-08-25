#!/bin/bash

# Given the files in the current folder, this script merges the first and second into a video slide, then the third and fourth and so on.

declare -a files=(*)
for (( i = 0; i < ${#files[*]}; ++ i ))
do
  slide-merger.sh "${files[$i]}" "${files[$i+1]}"
  ((++i))
done
