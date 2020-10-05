extends Panel

func set_value(value : float):
	$Hsplit/ProgressBar.value = max(0, value)
