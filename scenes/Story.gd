extends Control

func _back():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		_back()

func _on_Button_pressed():
	_back()
