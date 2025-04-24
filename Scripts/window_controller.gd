extends Window



var TYPES = {
	WindowManager.WindowType.NONE: {
		"scene": preload("res://Scenes/position_refrence.tscn"),
		"default_resolution" : Vector2(100.0, 100.0),
		"title": "",
		"icon": preload("res://Art/Transparent256x256.png")
	},
	WindowManager.WindowType.MUSIC_PLAYER : {
		"scene": preload("res://Scenes/Windows/music_player_window.tscn"),
		"default_resolution" : Vector2(339.0, 598.0),
		"title": "Music Player",
		"icon": preload("res://Art/Icons/atr_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
	}
}

@onready var window_control: Control = $WindowControl
@onready var spawn: Marker2D = $WindowControl/WindowUI/Spawn
@onready var title_node: Label = $WindowControl/WindowUI/TopBar/Title
@onready var icon_node: TextureRect = $WindowControl/WindowUI/TopBar/Icon

var down_pos_win : Vector2 = Vector2.ZERO
var down_pos_mouse : Vector2 = Vector2.ZERO

var spawn_held : bool = false
var type : int = WindowManager.WindowType.NONE

var scene : PackedScene
var resolution : Vector2
var text : String
var icon
var on_close : Callable

func _ready() -> void:
	if not scene: scene = TYPES[type]["scene"]
	if not resolution: resolution = TYPES[type]["default_resolution"]
	if not text: text = TYPES[type]["title"]
	if not icon: icon = TYPES[type]["icon"]
	
	size = resolution
	window_control.add_child(scene.instantiate())
	title_node.text = text
	icon_node.texture = icon
	
	if spawn_held:
		DisplayServer.window_set_position(PositionRefrence.get_global_mouse_position() + spawn.position + Vector2(1600, -30), get_window_id())
		drag_start()
	

func _process(delta: float) -> void:
	if down_pos_mouse != Vector2.ZERO:
		DisplayServer.window_set_position(PositionRefrence.get_global_mouse_position() - down_pos_mouse + down_pos_win, get_window_id())
	
	if spawn_held and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		spawn_held = false
		drag_end()

func _on_drag_button_down() -> void:
	drag_start()


func _on_drag_button_up() -> void:
	drag_end()


func _on_minimize_pressed() -> void:
	pass # need to set up app manager
	#hide()


func _on_exit_pressed() -> void:
	on_close.call()
	queue_free()


func drag_start():
	down_pos_win = DisplayServer.window_get_position(get_window_id())
	down_pos_mouse = PositionRefrence.get_global_mouse_position()

func drag_end():
	down_pos_win = Vector2.ZERO
	down_pos_mouse = Vector2.ZERO
