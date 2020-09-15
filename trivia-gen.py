import glob
import os
import random
import sys
from ffprobe import FFProbe
import subprocess

PATH = os.path.split(os.path.abspath(__file__))[0]
SLIDES_PATH = PATH + '/slides'
TOTAL_LENGTH = 600


def main():
    randomized_list = [name for name in glob.glob(SLIDES_PATH + '/*') if
                       not name.endswith('_a.jpg') and not name.endswith('_c.jpg') and not name.endswith('_a.jpeg') and not name.endswith('_c.jpeg') and not name.endswith(
                           '_a.png') and not name.endswith('_c.png')]
    random.shuffle(randomized_list)

    current_time = 0

    batches = []
    current_batch = []
    while current_time < TOTAL_LENGTH:
        next_slide = randomized_list.pop(0)
        original_name, original_extension = os.path.splitext(next_slide)
        name = original_name.lower()
        extension = original_extension.lower()
        if extension == '.jpg' or extension == '.jpeg' or extension == '.png':
            current_batch.append(next_slide)
            add_time = 15
            if name.endswith('_q'):
                if os.path.isfile(original_name[0:len(original_name) - 2] + '_c' + original_extension):
                    current_batch.append(original_name[0:len(original_name) - 2] + '_c' + original_extension)
                    add_time += 15
                current_batch.append(original_name[0:len(original_name) - 2] + '_a' + original_extension)
                add_time += 15
            current_time += add_time
        elif extension == '.mp4':
            if len(current_batch) > 0:
                batches.append(current_batch)
            batches.append(next_slide)
            current_batch = []
            metadata = FFProbe(next_slide)
            current_time += metadata.video[0].duration_seconds()

    if len(current_batch) > 0:
        batches.append(current_batch)

    videos = []
    deletes = []
    index = 0
    for batch in batches:
        if isinstance(batch, list):
            f = open(PATH + '/tmp.txt', 'a')
            for slide in batch:
                f.write('file \'')
                f.write(slide)
                f.write('\'\n')
            f.close()
            out = PATH + '/out' + str(index) + '.mp4'
            subprocess.run(
                ['ffmpeg', '-y', '-hide_banner', '-loglevel', 'panic', '-f', 'concat', '-safe', '0', '-i', PATH + '/tmp.txt', '-vcodec', 'libx265', '-pix_fmt', 'yuv420p', '-vf',
                 'zoompan=d=(14+1)/1:s=1920x1080:fps=1/1,framerate=30:interp_start=0:interp_end=255:scene=100', out])
            os.remove(PATH + '/tmp.txt')

            out_audio = PATH + '/out' + str(index) + '_audio.mp4'
            subprocess.run(
                ['ffmpeg', '-y', '-hide_banner', '-loglevel', 'warning', '-f', 'lavfi', '-i', 'anullsrc', '-i', out, '-c:v', 'copy', '-c:a', 'aac', '-shortest', out_audio])

            videos.append(out_audio)
            deletes.append(out)
            deletes.append(out_audio)
            index += 1
        else:
            videos.append(batch)

    command = ['ffmpeg', '-y', '-hide_banner', '-loglevel', 'warning']
    filter_string = ''

    index = 0
    for video in videos:
        command.append('-i')
        command.append(video)
        filter_string += '[' + str(index) + ':v] [' + str(index) + ':a] '
        index += 1
    filter_string += 'concat=n=' + str(index) + ':v=1:a=1 [v] [a]'

    command.append('-filter_complex')
    command.append(filter_string)
    command.append('-map')
    command.append('[v]')
    command.append('-map')
    command.append('[a]')
    command.append('-vsync')
    command.append('vfr')
    command.append('-vcodec')
    command.append('libx265')
    command.append(PATH + '/trivia.mp4')
    subprocess.run(command)
    for file in deletes:
        os.remove(file)


# Run
if __name__ == '__main__':
    if len(sys.argv) > 1:
        TOTAL_LENGTH = int(sys.argv[1])
    main()
