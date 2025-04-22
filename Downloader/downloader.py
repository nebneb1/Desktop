import os
import yt_dlp
import pytube

ARGUMENT_DIRECTORY = "C:/Users/Hadey/AppData/Roaming/Godot/app_userdata/Desktop/downloader"
OUTPUT_DIRECTORY = "C:/Users/Hadey/AppData/Roaming/Godot/app_userdata/Desktop/playlists/"
ORDER_FILENAME = ".order"
ICON_FILENAME = f".icon"

arg_file = open(ARGUMENT_DIRECTORY + "/arguments.dat")
link = arg_file.readline()
loc = arg_file.readline()
counter = 0
arg_file.close()

def download_audio(url, output_dir):
    titles = []
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': os.path.join(output_dir, '%(title)s.%(ext)s'),
        'ffmpeg_location': r'C:\Users\Hadey\Documents\zips\ffmpeg-master-latest-win64-gpl-shared\ffmpeg-master-latest-win64-gpl-shared\bin',
        'extractaudio': True,
        'audioformat': 'mp3',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
        'noplaylist': False,
        'quiet': False,
        'verbose': True,
        'ignoreerrors': True,
        'progress_hooks': [download_hook],
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info_dict = ydl.extract_info(url, download=False)
        one_title = info_dict['title']

        if 'entries' in info_dict:
            titles = [entry.get('title') for entry in info_dict['entries'] if entry]


        ydl.download([url])
    if not loc:
        return titles
    else:
        return one_title


def download_hook(d):
    if d['status'] == 'finished':
        if loc == "":
            comm = open(ARGUMENT_DIRECTORY + "/communication.dat", "w")
            print(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'] + "|" + str(d['elapsed']) + "|" + str(d["info_dict"]["n_entries"]) + "|" + str(d["info_dict"]["playlist_index"]))
            comm.write(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'] + "|" + str(d['elapsed']) + "|" + str(d["info_dict"]["n_entries"]) + "|" + str(d["info_dict"]["playlist_index"]))
            comm.close()
        else:
            comm = open(ARGUMENT_DIRECTORY + "/communication.dat", "w")
            print(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'])
            comm.write(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'])
            comm.close()


def download_thumbnail(url, output_dir):
    ydl_opts = {
        'skip_download': True,
        'noplaylist': True,
        'quiet': False,
        'verbose': True,
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)

        if 'entries' in info:
            first_entry = next((e for e in info['entries'] if e), None)
        else:
            first_entry = info

        if not first_entry:
            print("No valid video found.")
            return

        thumbnail_url = first_entry.get('thumbnail')
        filename = os.path.join(output_dir, ICON_FILENAME + f".png")

        import urllib.request
        urllib.request.urlretrieve(thumbnail_url, filename)


if link.find("playlist") != -1:
    playlist = pytube.Playlist(link)
    title = playlist.title.lower()
    output = OUTPUT_DIRECTORY + title

    os.makedirs(output, exist_ok=True)

    songs = download_audio(link, output)
    file = open(output + "/" + ORDER_FILENAME, "w")
    for song in songs:
        file.write(song + ".mp3\n")
    file.close()

    download_thumbnail(link, output)

else:
    # vid = pytube.YouTube(link)
    # title = vid.title.lower()
    if len(loc) == 0:
        loc = "misc"

    output = OUTPUT_DIRECTORY + loc

    os.makedirs(output, exist_ok=True)

    song = str(download_audio(link, output))

    order = open(output + "/" + ORDER_FILENAME, "a")
    order.write(song + ".mp3\n")
    order.close()
