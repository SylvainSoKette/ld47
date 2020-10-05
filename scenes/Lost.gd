extends Control

func _back():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		_back()

func _on_Retry_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_Back_pressed():
	_back()
