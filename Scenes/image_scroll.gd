extends Node2D

@onready var image: TextureRect = $Image
@onready var music_player_margins: MarginContainer = $".."
@onready var fade: AnimationPlayer = $Fade
@onready var afk: Timer = $AFK

const SCREEN_SIZE = Vector2(339.0, 598.0)
const SPEED = 4.0
const AT_SIZE = 640

const AFK_TIME = 1000.0

const FADE_TIME = 5.0
const RAND_CHANCE = 2
const animations = [
	[Vector2(0.0, 0.0), Vector2(0.0, 1.0)],
	[Vector2(0.25, 0.0), Vector2(0.25, 1.0)],
	[Vector2(0.5, 0.0), Vector2(0.5, 1.0)],
	[Vector2(0.75, 0.0), Vector2(0.75, 1.0)],
	[Vector2(1.0, 0.0), Vector2(1.0, 1.0)],
	[Vector2(0.0, 1.0), Vector2(0.0, 0.0)],
	[Vector2(0.25, 1.0), Vector2(0.25, 0.0)],
	[Vector2(0.5, 1.0), Vector2(0.5, 0.0)],
	[Vector2(0.75, 1.0), Vector2(0.75, 0.0)],
	[Vector2(1.0, 1.0), Vector2(1.0, 0.0)]
]

var curr_animation : Array
var goal : Vector2 = Vector2.ZERO
var start : Vector2 = Vector2.ZERO
var on : bool = false
var last_size : Vector2

func _ready() -> void:
	chose_new_animation()
	Music.image_scroll = self
	Music.request_icon()
	

func _process(delta: float) -> void:
	if on:
		position += position.direction_to(goal) * SPEED * last_size.y/AT_SIZE * delta
		if position.distance_to(goal) < SPEED * FADE_TIME * last_size.y/AT_SIZE:
			modulate.r = position.distance_to(goal)/(SPEED*FADE_TIME)
			image.material.set_shader_parameter("brightness", round(modulate.r * 10.0)/10.0)
			if position.distance_to(goal) < 1.0:
				chose_new_animation()
		
		elif position.distance_to(start) < SPEED * FADE_TIME:
			modulate.r = position.distance_to(start)/(SPEED*FADE_TIME)
			image.material.set_shader_parameter("brightness", round(modulate.r * 10.0)/10.0)
		
		else: image.material.set_shader_parameter("brightness", 1.0)


func _input(event: InputEvent) -> void:
	afk.start(AFK_TIME)
	if on:
		on = false
		hide()

func chose_new_animation():
	if randi_range(1, RAND_CHANCE) == 1:
		curr_animation = animations.pick_random()
	else:
		curr_animation = [Vector2(randf(), randf()), Vector2(randf(), randf())]
		var count = 0
		while curr_animation[0].distance_to(curr_animation[1]) < 0.5 and count < 100:
			curr_animation = [Vector2(randf(), randf()), Vector2(randf(), randf())]
			count += 1
	
	start = -convert_relitive_to_pixels(curr_animation[0])
	goal = -convert_relitive_to_pixels(curr_animation[1])
	position = start

func convert_relitive_to_pixels(from: Vector2):
	if image.texture:
		last_size = image.texture.get_size()
		var image_space = last_size - SCREEN_SIZE
		return image_space * from
	

func change_image(path : String):
	image.texture = ImageTexture.create_from_image(load(path))

func _on_afk_timeout() -> void:
	on = true
	chose_new_animation()
	fade.play("fade_in")
	show()
