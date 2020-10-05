extends KinematicBody2D

class_name Player

signal oxygen_changed(value)
signal food_changed(value)
signal help_changed(value)

export (float) var move_speed := 160.0
export (float) var dash_speed := 720.0
export (float) var dash_duration := 0.2

onready var current_speed := move_speed
var dashing := false
var dead := false
var animation_switcheroo = {
	"idle": "idle",
	"move": "move",
	"call": "call",
	"recharge": "idle", # todo CHANGE ME TO RECHARGE ANIMATION
	"rescued": "idle",  # todo CHANGE ME TO RESCUED ANIMATION
	"dead": "dead",
}

onready var animation_player = $AnimationPlayer
onready var action_area = $ActionArea
onready var stats = $Stats

onready var air_sound = $Sounds/Air
onready var gasping_sound = $Sounds/Gasping
onready var calling_sound = $Sounds/Calling
onready var gulping_sound = $Sounds/Gulping
onready var hungry_sound = $Sounds/Hungry
onready var pop_sound = $Sounds/Pop

func _process(delta):
	if stats.help_progress >= 100.0:
		_rescue()

func _physics_process(delta):
	if !dead:
		_check_death()
		_move()
		_dash()
		_pickup()
		_call_for_help(delta)
		_recharge_oxygen(delta)
	else:
		animation_player.play(animation_switcheroo["dead"])

func _check_death():
	if stats.oxygen < 20.0 and !gasping_sound.playing:
		gasping_sound.play(0.0)
	else:
		gasping_sound.stop()

	if stats.food < 20.0 and !hungry_sound.playing:
		hungry_sound.play(0.0)
	else:
		hungry_sound.stop()

	if stats.oxygen <= 0.001 or stats.food <= 0.001:
		die(false)

func _move():
	var dir := Vector2.ZERO
	
	dir.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y += Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	dir = dir.normalized()

	if dir == Vector2.ZERO:
		animation_player.play(animation_switcheroo["idle"])
	else:
		animation_player.play(animation_switcheroo["move"])

	move_and_slide(dir * current_speed)

func _dash():
	if !dashing and Input.is_action_just_pressed("dash"):
		dashing = true

	if dashing:
		current_speed = dash_speed
		yield(get_tree().create_timer(dash_duration), "timeout")
		current_speed = move_speed
		dashing = false

func _pickup():
	if Input.is_action_just_released("use"):
		for snack in action_area.get_overlapping_areas():
			if snack is Snack:
				gulping_sound.play(0.0)
				stats.consume_food(snack.get_nutritive_value())
				snack.queue_free()

func _call_for_help(delta):
	if Input.get_action_strength("use"):
		for phone in action_area.get_overlapping_areas():
			if phone is Phone:
				if !calling_sound.is_playing():
					calling_sound.play(0.0)
				animation_player.play(animation_switcheroo["call"])
				stats.call_help(phone.get_progress(delta))
	else:
		calling_sound.stop()

func _recharge_oxygen(delta):
	if Input.get_action_strength("use"):
		for oxygen in action_area.get_overlapping_areas():
			if oxygen is OxygenTank:
				if !air_sound.is_playing():
					air_sound.play(0.0)
				animation_player.play(animation_switcheroo["recharge"])
				stats.consume_oxygen(oxygen.get_oxygen(delta))
	else:
		air_sound.stop()

func _rescue() -> void:
	animation_player.play(animation_switcheroo["rescued"])
	yield(animation_player, "animation_finished")
	get_tree().change_scene("res://scenes/Win.tscn")

func die(ran_over : bool) -> void:
	dead = true
	animation_player.play(animation_switcheroo["dead"])
	$CollisionShape2D.set_disabled(true)
	if ran_over:
		$Sprite.set_visible(false)
		$Particles2D.set_emitting(true)
		yield(get_tree().create_timer($Particles2D.lifetime), "timeout")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://scenes/Lost.tscn")

func _on_Stats_oxygen_changed(value):
	emit_signal("oxygen_changed", value)

func _on_Stats_food_changed(value):
	emit_signal("food_changed", value)

func _on_Stats_help_changed(value):
	emit_signal("help_changed", value)

func _on_ActionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	if area is Snack:
		area.enable_tooltip(true)
	if area is Phone:
		area.enable_tooltip(true)
	if area is OxygenTank:
		area.enable_tooltip(true)

func _on_ActionArea_area_shape_exited(area_id, area, area_shape, self_shape):
	if area is Snack:
		area.enable_tooltip(false)
	if area is Phone:
		area.enable_tooltip(false)
	if area is OxygenTank:
		area.enable_tooltip(false)
