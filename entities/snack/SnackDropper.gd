extends Area2D

export (float) var spawn_radius := 20.0
export (float) var drop_rate := 0.1
export (PackedScene) var snack

func _ready():
	randomize()

func _on_SnackDropper_body_entered(body):
	if randf() <= drop_rate:
		var s = snack.instance()
		s.position.x += randf() * spawn_radius - spawn_radius/2
		s.position.y += randf() * spawn_radius - spawn_radius/2
		add_child(s)
