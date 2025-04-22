extends MarginContainer

@onready var icon: TextureRect = $Info/Icon
@onready var playlist_title: Label = $Info/SidebarMargins/Sidebar/PlaylistTitle
@onready var num_songs: Label = $Info/SidebarMargins/Sidebar/NumSongs
@onready var boot_bg: ColorRect = $Info/Icon/BootMargins/BootBG


const FALLBACK_ICON = preload("res://Art/.png")

var shuffle : bool = false
var after : bool = false
var playlist = "playlist"
var directory : String

func _ready():
	directory = Music.SONG_DIRECTORY + playlist + "/"
	for file in DirAccess.get_files_at(directory):
		if file.begins_with(Music.ICON_NAME):
			icon.texture = ImageTexture.create_from_image(Image.load_from_file(directory + file))
	
	if FileAccess.file_exists(directory + Music.ORDER_NAME):
		num_songs.text = str(FileAccess.get_file_as_string(directory + Music.ORDER_NAME).split("\n").size()) + " Songs"
		
	playlist_title.name = playlist.capitalize()
	
	if Global.load_file("default_playlist") == playlist:
		grab_focus()
		

func _on_boot_pressed() -> void:
	Global.save_file("default_playlist", playlist)


func _on_play_after_pressed() -> void:
	pass 


func _on_select_pressed() -> void:
	if DirAccess.dir_exists_absolute(directory):
		Music.load_playlist(playlist, shuffle, after)
