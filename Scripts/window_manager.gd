extends Node

enum WindowType {
	NONE,
	MUSIC_PLAYER
}

const WINDOW = preload("res://Scenes/window.tscn")
func empty(): pass

func create_window(type : WindowType, spawn_held : bool = false, on_close : Callable = empty, scene = null, resolution = null, text = null, icon = null):
	var inst = WINDOW.instantiate()
	inst.type = type
	inst.spawn_held = spawn_held
	inst.on_close = on_close
	
	if scene: inst.scene = scene
	if resolution: inst.resolution = resolution
	if text: inst.text = text
	if icon: inst.icon = icon
	
	
	get_tree().root.add_child(inst)
