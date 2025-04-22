extends Node

@export var time_from_start: Label
@export var total_time: Label
@export var pause: Button
@export var previous: Button
@export var next: Button
@export var progress: HSlider
@export var song: Label

func _ready() -> void:
	connect_to_player()

func connect_to_player():
	if Music.time_from_start: 
		time_from_start.text = Music.time_from_start.text
	Music.time_from_start = time_from_start
	
	if Music.total_time:
		time_from_start.total_time = Music.total_time.text
	Music.total_time = total_time
	
	if Music.pause_button:
		pause.icon = Music.pause_button.icon
	Music.pause_button = pause
	
	if Music.progress:
		progress.max_value = Music.progress.max_value
		progress.value = Music.progress.value
	Music.progress = progress
	
	if Music.song:
		song.text = Music.song.text
	Music.song = song
	
	previous.pressed.connect(Music.on_previous_pressed)
	next.pressed.connect(Music.on_next_pressed)
	pause.pressed.connect(Music.on_pause_pressed)
	progress.drag_started.connect(Music.on_progress_drag_started)
	progress.drag_ended.connect(Music.on_progress_drag_ended)
	
	
#func on_previous_pressed()
#func on_next_pressed()
#func on_pause_pressed()
#func on_progress_drag_started()
#func on_progress_drag_ended(value_changed: bool)
	
