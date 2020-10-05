extends Control

func _quit():
	get_tree().quit()

func _input(event):
	if Input.is_action_just_released("ui_cancel"):
		_quit()

func _on_Quit_pressed():
	_quit()

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Story_pressed():
	get_tree().change_scene("res://scenes/Story.tscn")

func _on_Controls_pressed():
	get_tree().change_scene("res://scenes/Controls.tscn")
