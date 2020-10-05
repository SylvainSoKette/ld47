extends Area2D

class_name OxygenTank

export (float) var oxygen := 200.0
export (float) var oxygen_flow := 35.0

onready var tooltip = $Tooltip
onready var sprite = $Sprite

func _ready():
	randomize()
	tooltip.set_visible(false)

func _process(delta):
	if oxygen > 0.05:
		sprite.set_frame(0)
	else:
		sprite.set_frame(1)

func enable_tooltip(b : bool) -> void:
	tooltip.set_visible(b)

func get_oxygen(delta) -> float:
	var value = delta * oxygen_flow
	oxygen = max(0, oxygen - value)
	return min(oxygen, value)
