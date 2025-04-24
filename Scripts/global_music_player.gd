extends AudioStreamPlayer

var time_from_start: Label
var total_time: Label
var pause_button: BaseButton
var progress: HSlider
var song: Label
var image_scroll : Node2D

@onready var timer: Timer = $Timer

const SONG_DIRECTORY = "user://playlists/"
const ORDER_NAME = ".order"
const ICON_NAME = ".icon"
const PAUSE = preload("res://Art/PasswordPassword/pause.svg")
const PLAY = preload("res://Art/PasswordPassword/play.svg")
const REFRESH_TIME = 0.5 
const MAX_HISTORY = 100

signal update_playlists

var current_song : String
var action_buttons : Control
var default_playlist = "password"
var playlist : String
var last_shuffle : bool = false
var loop_one : String = ""
var playlists : Array
var song_queue : Array
var song_history : Array
#var paused : bool = false

func _ready() -> void:
	Music.call_deferred("start")

func start():
	playlists = DirAccess.get_directories_at(SONG_DIRECTORY)
	default_playlist = Global.load_file("default_playlist", default_playlist)
	
	if default_playlist in playlists: 
		load_playlist(default_playlist, true)

func next_song():
	if loop_one != "":
		load_song(loop_one)
	elif song_queue.size() > 0:
		load_song(song_queue[0])
		add_to_history(song_queue.pop_front())
	else:
		load_playlist(playlist.split("/")[-2], last_shuffle)


func previous_song():
	if loop_one != "":
		load_song(loop_one)
	elif song_history.size() > 1:
		song_queue.push_front(pop_history())
		load_song(song_history[-1])
	elif song_history.size() == 1:
		load_song(song_history[0])
		

func load_song(path : String):
	if path.ends_with("/"): return
	var type = path.split(".")[-1]
	current_song = path.split("/")[-1]
	match type:
		"mp3":
			stream = AudioStreamMP3.load_from_file(path)
		"ogg":
			stream = AudioStreamOggVorbis.load_from_file(path)
		"wav":
			stream = AudioStreamWAV.load_from_file(path)
		_:
			printerr("Song \"", path, "\" appears to be the wrong file type")
			return false
	
	var time : int = ceil(stream.get_length())
	total_time.text = str(time/60) + ":" + ("0" if time%60 < 10 else "") + str(time%60)
	time_from_start.text = ("0" if time/60 >= 10 else "") + "0:00" 
	song.scroll_text = current_song
	progress.max_value = time
	progress.value = 0.0
	play_song()
	play()
	timer.start(REFRESH_TIME)

func pause_song():
	set_stream_paused(true)
	if pause_button is TextureButton:
		pause_button.texture_normal = PLAY
	else:
		pause_button.icon = PLAY

func play_song():
	set_stream_paused(false)
	if pause_button is TextureButton:
		pause_button.texture_normal = PAUSE
	else:
		pause_button.icon = PAUSE

func load_playlist(id : String, shuffle_override : bool = false, after_override : bool = false):
	var shuffle = action_buttons.shuffle or shuffle_override
	var after = action_buttons.play_after or after_override
	
	
	playlist = SONG_DIRECTORY + id + "/"
	last_shuffle = shuffle
	var new_music : Array = FileAccess.get_file_as_string(playlist + ORDER_NAME).replace("\r", "").split("\n")
	
	if shuffle: 
		new_music.shuffle()
	
	var temp = []
	for music in new_music:
		if music != "":
			temp.append(playlist + music)
	
	new_music = temp
	
	if not after:
		song_queue = new_music
	
	else:
		song_queue.append_array(new_music)
	
	loop_one = ""
	action_buttons.set_boot(Global.load_file("default_playlist") == id)
	request_icon()
	
	
	if song_queue.size() > 1:
		if not after: next_song()
		return true
	else:
		return false

func add_to_history(song_path : String):
	song_history.append(song_path)
	if song_history.size() > MAX_HISTORY:
		song_history.pop_front()

func pop_history():
	if song_history.size() > 0:
		return song_history.pop_back()
	else:
		return ""

func download(ytlink : String): pass

func request_icon():
	for file in DirAccess.get_files_at(playlist):
		if file.begins_with(Music.ICON_NAME) and is_instance_valid(image_scroll):
			image_scroll.image.texture = ImageTexture.create_from_image(Image.load_from_file(playlist + file))

func on_previous_pressed() -> void: 
	previous_song()
	
func on_next_pressed() -> void: 
	next_song()
	
func on_pause_pressed() -> void: 
	if get_stream_paused(): 
		play_song()
	else: 
		pause_song()
	
func _on_finished() -> void:
	next_song()
	
func _on_timer_timeout() -> void:
	var time : int =  int(get_playback_position())
	progress.value = time
	time_from_start.text = str(time/60) + ":" + ("0" if time%60 < 10 else "") + str(time%60)
	timer.start(REFRESH_TIME)

var dragging = false
func on_progress_drag_started() -> void:
	timer.stop()
	dragging = true
	
func _process(delta: float):
	if dragging:
		var time : int = int(progress.value)
		time_from_start.text = str(time/60) + ":" + ("0" if time%60 < 10 else "") + str(time%60)
		

func on_progress_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var time : int = int(progress.value)
		play(progress.value)
		time_from_start.text = str(time/60) + ":" + ("0" if time%60 < 10 else "") + str(time%60)
	timer.start(REFRESH_TIME)
	

func update_title():
	song.scroll_text = current_song
