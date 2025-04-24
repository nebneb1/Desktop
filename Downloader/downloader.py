import os
import yt_dlp
import pytube
import codecs

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
        'force_generic_extractor': True,
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        # info_dict = ydl.extract_info(url, download=False)
        # try:
        #     one_title = info_dict['title']
        #     if 'entries' in info_dict:
        #         titles = [entry.get('title') for entry in info_dict['entries'] if entry]
        #
        # except:
        #     one_title = "NA"


        ydl.download([url])


def download_hook(d):
    if d['status'] == 'finished':
        if loc == "":
            comm = codecs.open(ARGUMENT_DIRECTORY + "/communication.dat", "w", "utf-8")
            print(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'] + "|" + str(d['elapsed']) + "|" + str(d["info_dict"]["n_entries"]) + "|" + str(d["info_dict"]["playlist_index"]))
            comm.write(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'] + "|" + str(d['elapsed']) + "|" + str(d["info_dict"]["n_entries"]) + "|" + str(d["info_dict"]["playlist_index"]))
            comm.close()
        else:
            comm = codecs.open(ARGUMENT_DIRECTORY + "/communication.dat", "w", "utf-8")
            print(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'])
            comm.write(d["_speed_str"] + "|" + d["_total_bytes_str"] + "|" + d["info_dict"]['id'] + "|" + d["info_dict"]['title'])
            comm.close()


def download_thumbnail(url, output_dir):
    from urllib.request import urlretrieve
    from pytube import Playlist, YouTube

    playlist = Playlist(url)
    first_video_url = next(iter(playlist.video_urls), None)

    if not first_video_url:
        print("No valid video in playlist.")
        return

    ydl_opts = {
        'skip_download': True,
        'quiet': False,
        'verbose': True,
        'force_generic_extractor': True,
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(first_video_url, download=False)

        thumbnail_url = info.get('thumbnail')
        if not thumbnail_url:
            print("No thumbnail found.")
            return

        filename = os.path.join(output_dir, ICON_FILENAME + ".jpg")
        urlretrieve(thumbnail_url, filename)
        print(f"Thumbnail downloaded: {filename}")


def get_playlist_titles(playlist_url):
    ydl_opts = {
        'quiet': True,
        'extract_flat': True,
        'skip_download': True,
        'noplaylist': False,
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            info_dict = ydl.extract_info(playlist_url, download=False)
        except Exception as e:
            print(f"Error extracting playlist: {e}")
            return []

    if 'entries' not in info_dict:
        print("No entries found in playlist.")
        return []

    return [entry.get('title', 'unknown') for entry in info_dict['entries'] if entry]

def get_video_title(video_url):
    ydl_opts = {
        'quiet': True,
        'extract_flat': True,  # Only fetch metadata, no download
        'skip_download': True,
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info_dict = ydl.extract_info(video_url, download=False)

            if 'title' not in info_dict:
                print("Error: Unable to retrieve video title.")
                return None

            return info_dict['title']

    except Exception as e:
        print(f"Error extracting video: {e}")
        return None

if link.find("playlist") != -1:
    playlist = pytube.Playlist(link)
    title = playlist.title.lower()
    output = OUTPUT_DIRECTORY + title

    os.makedirs(output, exist_ok=True)

    songs = get_playlist_titles(link)
    print(songs)
    file = open(output + "/" + ORDER_FILENAME, "w")
    for song in songs:
        file.write(song + ".mp3\n")
    file.close()

    download_audio(link, output)
    download_thumbnail(link, output)

else:
    # vid = pytube.YouTube(link)
    # title = vid.title.lower()
    if len(loc) == 0:
        loc = "misc"

    output = OUTPUT_DIRECTORY + loc

    os.makedirs(output, exist_ok=True)

    download_audio(link, output)

    song = get_video_title(link)
    test = open(output + "/" + ORDER_FILENAME, "r")
    text = test.read()
    test.close()
    if not song + ".mp3\n" in text:
        order = open(output + "/" + ORDER_FILENAME, "a")
        order.write(song + ".mp3\n")
        order.close()
