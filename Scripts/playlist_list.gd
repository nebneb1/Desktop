extends VBoxContainer

const PLAYLIST_SELECTION = preload("res://Scenes/playlist_selection.tscn")

func _ready() -> void:
	reload_playlists()

func reload_playlists():
	for child in get_children(): child.queue_free()
	
	for playlist in DirAccess.get_directories_at(Music.SONG_DIRECTORY):
		var inst = PLAYLIST_SELECTION.instantiate()
		inst.playlist = playlist
		add_child(inst)
