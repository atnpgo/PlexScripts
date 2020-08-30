A collection of scripts for use with Plex/Tautulli and a custom pre-roll generation script.

* lights-controller.sh can be used to control lights on a Phillips Hue system. Depends on `curl`
* trivia-gen.sh will transform a collection of video slides into a random subset of 20 videos (15 seconds each, 5 minutes total). Depends on [editly](https://github.com/mifi/editly)
* slide-to-vid.sh will transform a single image into a 15 second video slide. Depends on `ffmpeg`.
* slide-merger.sh will transform a pair of images (question/answer) into a single 15 second video slide (10 seconds question, 5 second answer). Depends on `ffmpeg`.
* bulk-merge.sh will take merge every other file in the current folder together. i.e. The first and the second, the third and the fourth, the fifth and the sixth, etc. Depends on `ffmpeg`.
