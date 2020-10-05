extends KinematicBody2D

class_name Train

export var move_speed : float = 4096.0
export var move_right := true

onready var move_direction := Vector2.RIGHT if move_right else Vector2.LEFT
onready var screen_size : Vector2 = get_viewport().get_visible_rect().size

func _ready():
	randomize()
	$Sprite.flip_h = move_right
	if move_right:
		$BackLight.position.x = -$BackLight.position.x
		$FrontLight.position.x = -$FrontLight.position.x

func _process(delta):
	_move(delta)
	_clamp_position()
	if 0 < position.x and position.x < 960:
		$AudioStreamPlayer.play(0.0)

func _move(delta):
	var collision : KinematicCollision2D
	collision = move_and_collide(move_direction * move_speed * delta)
	if collision and collision.collider is Player:
		collision.collider.die(true)

func _clamp_position():
	var distance := 8192.0

	if position.x > distance + screen_size.x:
		position.x -= distance + screen_size.x + rand_range(512, distance-1)
		$AudioStreamPlayer.stop()
	if position.x < -distance:
		position.x += distance + screen_size.x + rand_range(512, distance-1)
		$AudioStreamPlayer.stop()
