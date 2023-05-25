extends TextureProgressBar

func _process(delta):
	if value <= 100:
		value += 1 * delta
		
	if InputEventMouseButton:
			value -= 10

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.:
#			value -= 10

