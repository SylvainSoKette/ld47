extends Node

signal food_changed(value)
signal oxygen_changed(value)
signal help_changed(value)

export (float) var food_consumption := 1 # per second
export (float) var oxygen_consumption := 1 # per second

var food := 100.0
var oxygen := 100.0
var help_progress := 0.0
var paused = false

func _ready():
	emit_signal("help_changed", help_progress)

func consume_food(amout : float) -> void:
	food = clamp(food + amout, 0, 100)
	emit_signal("food_changed", food)

func consume_oxygen(amout : float) -> void:
	oxygen = clamp(oxygen + amout, 0, 100)
	emit_signal("oxygen_changed", oxygen)

func call_help(amount : float) -> void:
	help_progress = clamp(help_progress + amount, 0, 100)
	emit_signal("help_changed", help_progress)

func _process(delta) -> void:
	if !get_parent().dead:
		consume_food(-food_consumption * delta)
		consume_oxygen(-oxygen_consumption * delta)
