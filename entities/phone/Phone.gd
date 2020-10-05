extends Area2D

class_name Phone

export (float) var help_speed := 5.0

onready var tooltip = $Tooltip
onready var sprite = $Sprite

func _ready():
	randomize()
	tooltip.set_visible(false)

func _process(delta):
	sprite.set_frame(0)

func enable_tooltip(b : bool) -> void:
	tooltip.set_visible(b)

func get_progress(delta) -> float:
	sprite.set_frame(1)
	var progress_value = randf() * help_speed * delta
	return progress_value
