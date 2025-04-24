extends Control

@export var button : Button
@export var baseline_offset : float
@export var max_offset : float 
@export var is_music : bool

const TARG_SPEED = 10.0
const POP_OUT_DIST = 50.0

signal pop_out

var dist : float = 0.0
var og : float = 0.0
var original_pos : Vector2
var down : bool = false
var targ : float = 0.0

func _ready() -> void:
	targ = baseline_offset
	button.button_down.connect(_on_button_press)
	button.button_up.connect(_on_button_release)

func _process(delta: float) -> void:
	#print(offset_top)
	#offset_top = -400
	if down:
		dist = get_global_mouse_position().y - original_pos.y #+ baseline_offset
		offset_top = og + dist
		if abs(get_global_mouse_position().x - original_pos.x) > POP_OUT_DIST:
			pop_out.emit()
			_on_button_release()
	else:
		offset_top += delta * TARG_SPEED * (targ - offset_top)


func _on_button_press():
	down = true
	dist = 0.0
	og = offset_top
	original_pos = get_global_mouse_position()

func _on_button_release():
	down = false
	
	if abs(offset_top - max_offset) > abs(offset_top - baseline_offset)*2:
		if abs(dist) > 10.0: targ = baseline_offset
		else: targ = max_offset
	else: 
		if abs(dist) > 10.0: targ = max_offset
		else: targ = baseline_offset
