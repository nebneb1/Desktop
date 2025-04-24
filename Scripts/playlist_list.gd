extends VBoxContainer

const PLAYLIST_SELECTION = preload("res://Scenes/playlist_selection.tscn")
const PLAYLIST_BUFFER = preload("res://Scenes/playlist_buffer.tscn")

func _ready() -> void:
	reload_playlists()

func reload_playlists():
	for child in get_children(): child.queue_free()
	
	for playlist in DirAccess.get_directories_at(Music.SONG_DIRECTORY):
		var inst = PLAYLIST_SELECTION.instantiate()
		inst.playlist = playlist
		add_child(inst)
	
	var inst = PLAYLIST_BUFFER.instantiate()
	add_child(inst)
