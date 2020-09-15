A collection of scripts for use with Plex/Tautulli and a custom pre-roll generation script.


### lights-controller.sh

Script used to control lights on a Phillips Hue system. Depends on `curl`. Recommended setup is adding this as a script to run in **Tautuli**.

To obtain the ID to use for the script, follow the [basic Hue API](https://developers.meethue.com/develop/get-started-2/) tutorial to generate one.

The first script will setup the lights for the main movie and the second for the pre-show trivia and trailers.

##### Script 1
* Conditions:
    * `Media Type` is `movie`
    * `Library Name` is `Movies` (adjust this to match your own library name)
* Triggers and arguments:
    * Playback Start `off [ID]`
    * Playback Stop `on [ID]`
    * Playback Pause `dim [ID]`
    * Playback Resume `off [ID]`
##### Script 2
* Conditions:
    * `Media Type` is `clip`
* Triggers and arguments:
    * Playback Start `dim [ID]`

### trivia-gen.sh  
Script used to transform a collection of videos and video slides into a random subset that will be at least as long as the requested length (defaults to 10 minutes) before the 
transitions are applied. 

Depends on ffmpeg (`brew install ffmpeg`, `apt-get install ffmpeg`, `choco install ffmpeg`, etc.) and ffprobe-python (`pip install ffprobe-python`). 
Works by building a list of random slides/videos until the length of the generated video is at least 600 seconds (pass a number as the first argument to use that number of seconds instead), does a first pass merging the 
different sets of slides together with a fade, then does a second pass concatenating the videos generated in the first pass and the randomly chosen videos.
Simply place the videos and image slides in the `slides/` subfolder before running, each image slide accounts for 15 seconds. 
The script will fail with errors if there isn't enough videos to satisfy the length requirement.
For Q&A style slides, the first slide should be named `{name}_q.{ext}` (question) and the last slide `{name}_a.{ext}` (answer) with an optional clue slide between them named `{name}_c.{ext}`
Videos should be in mp4/h265 format and have a resolution of 1920x1080, concatenation will fail if there is a mismatch and this is the format generated for images. 
You can convert them using Handbrake, ffmpeg, or several other solution.

##### Tautulli Script
* Conditions:
    * `Media Type` is `movie`
    * `Library Name` is `Movies` (adjust this to match your own library name)
* Triggers and arguments:
    * Playback Stop `nopythonpath`
