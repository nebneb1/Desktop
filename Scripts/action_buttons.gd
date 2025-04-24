extends HBoxContainer

@onready var play_after_button: TextureButton = $PlayAfter
@onready var shuffle_button: TextureButton = $Shuffle
@onready var boot_button: TextureButton = $Boot

const BOOT_ON = preload("res://Art/Icons/visibility_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const BOOT_OFF = preload("res://Art/Icons/visibility_off.png")
const PLAY_AFTER_ON = preload("res://Art/Icons/graph_6_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const PLAY_AFTER_OFF = preload("res://Art/Icons/graph_off_alt.png")
const SHUFFLE_ON = preload("res://Art/Icons/stream_200dp_FFFFFF_FILL0_wght400_GRAD0_opsz48.png")
const SHUFFLE_OFF = preload("res://Art/Icons/stream_off_alt.png")


var play_after = false
var shuffle = false
var boot = false

func set_play_after(to : bool):
	play_after = to
	if play_after:
		play_after_button.texture_normal = PLAY_AFTER_ON
	else:
		play_after_button.texture_normal = PLAY_AFTER_OFF

func set_shuffle(to : bool):
	shuffle = to
	if shuffle:
		shuffle_button.texture_normal = SHUFFLE_ON
	else:
		shuffle_button.texture_normal = SHUFFLE_OFF


func set_boot(to : bool):
	var temp = boot
	boot = to
	print(Music.playlist)
	
	if boot:
		boot_button.texture_normal = BOOT_ON
		if not temp: Global.save_file("default_playlist", Music.playlist.split("/")[-2])
	else:
		boot_button.texture_normal = BOOT_OFF
		if temp: Global.save_file("default_playlist", "password")


func _on_play_after_pressed() -> void:
	set_play_after(!play_after)

func _on_shuffle_pressed() -> void:
	set_shuffle(!shuffle)

func _on_boot_pressed() -> void:
	set_boot(!boot)

func _on_download_pressed() -> void:
	pass # Replace with function body.
