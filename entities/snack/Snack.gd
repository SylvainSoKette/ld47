extends Area2D

class_name Snack

var nutrition := 25.0
var nutrition_delta := 5.0

onready var animation_player = $AnimationPlayer
onready var tooltip = $Tooltip

func _ready():
	randomize()
	tooltip.set_visible(false)
	animation_player.play("Drop")

func enable_tooltip(b : bool) -> void:
	tooltip.set_visible(b)

func get_nutritive_value() -> float:
	return nutrition + nutrition_delta * randf()
