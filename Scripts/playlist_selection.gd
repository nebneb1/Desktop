extends MarginContainer

@onready var icon: TextureRect = $Info/Icon
@onready var playlist_title: Label = $Info/SidebarMargins/Sidebar/PlaylistTitle
@onready var num_songs: Label = $Info/SidebarMargins/Sidebar/NumSongs
@onready var boot_bg: ColorRect = $Info/Icon/BootMargins/BootBG


const FALLBACK_ICON = preload("res://Art/.png")
const PLAY_AFTER_ON = preload("res://Art/Icons/graph_6_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const PLAY_AFTER_OFF = preload("res://Art/Icons/graph_off.png")
const BOOT_ON = preload("res://Art/Icons/visibility_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const BOOT_OFF = preload("res://Art/Icons/visibility_off.png")
const SHUFFLE_ON = preload("res://Art/Icons/stream_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const SHUFFLE_OFF = preload("res://Art/Icons/stream_off.png")

var shuffle : bool = false
var after : bool = false
var playlist = "playlist"
var directory : String

func _ready():
	directory = Music.SONG_DIRECTORY + playlist + "/"
	for file in DirAccess.get_files_at(directory):
		if file.begins_with(Music.ICON_NAME):
			#print(icon.texture)
			icon.texture = ImageTexture.create_from_image(Image.load_from_file(directory + file))
			#print(icon.texture)
			break
	
	if FileAccess.file_exists(directory + Music.ORDER_NAME):
		num_songs.text = str(FileAccess.get_file_as_string(directory + Music.ORDER_NAME).split("\n").size()-1) + " Songs"
	
	playlist_title.text = playlist.capitalize()
	
	if (Music.playlist == "" and Global.load_file("default_playlist") == playlist) or (Music.playlist != "" and playlist == Music.playlist.split("/")[-2] and visible):
		print(playlist)
		$SelectHolder/Select.grab_focus()
		

func _on_select_pressed() -> void:
	if DirAccess.dir_exists_absolute(directory):
		Music.load_playlist(playlist)
