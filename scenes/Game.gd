extends Node

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://scenes/Menu.tscn")
