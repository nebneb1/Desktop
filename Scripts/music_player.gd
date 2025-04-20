extends VBoxContainer

@onready var time_from_start: Label = $Buttons/TimeFromStart
@onready var total_time: Label = $Buttons/TotalTime
@onready var pause: Button = $Buttons/Pause
@onready var progress: HSlider = $Progress
@onready var song: Label = $Song

const SONG_DIRECTORY = "user://playlists"

func _ready() -> void:
	print(DirAccess.get_directories_at(SONG_DIRECTORY))


func _on_previous_pressed() -> void:
	pass # Replace with function body.


func _on_pause_pressed() -> void:
	pass # Replace with function body.


func _on_next_pressed() -> void:
	pass # Replace with function body.
