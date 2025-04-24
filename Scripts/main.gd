extends Control

@onready var playlists: Control = $Playlists
@onready var playlist_gradient: TextureRect = $PlaylistGradient
@onready var music: VBoxContainer = $Playlists/Music

func _ready() -> void:
	playlists.connect("pop_out", popout_music_player)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func popout_music_player():
	playlists.hide()
	playlist_gradient.hide()
	WindowManager.create_window(WindowManager.WindowType.MUSIC_PLAYER, true, popin_music_player)

func popin_music_player(): 
	playlists.show()
	playlist_gradient.show()
	music.connect_to_player()
	Music.update_playlists.emit()
