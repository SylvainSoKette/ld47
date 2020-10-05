extends AnimationPlayer

func _ready():
	$ColorRect.set_visible(true)
	play("FadeIn")
