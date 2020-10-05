extends Control

func _on_Player_oxygen_changed(value):
	$Meters/Oxygen.set_value(value)

func _on_Player_food_changed(value):
	$Meters/Food.set_value(value)

func _on_Player_help_changed(value):
	$Meters/CallHelp.set_value(value)
