extends Control

@export var pos : Marker2D
@export var max : float = 150.0
@export var min : float = 100.0

func _process(delta: float) -> void:
	var dist : float
	if pos: dist = get_global_mouse_position().distance_to(pos.global_position)
	else: dist = get_global_mouse_position().distance_to(global_position)
	var ammount = clamp((dist-min)/(max-min), 0.0, 1.0)
	modulate.a = 1.0 - ammount
