extends Control

func _ready() -> void:
	Music.call_deferred("start")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
