extends TextureProgressBar

var mouse_left_down:bool
signal no_stamina
signal have_stamina

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
				mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
				mouse_left_down = false

func _process(_delta):
	if mouse_left_down:
		value -= 0.5
	else:
		value += 0.1
	
	if value == 0:
		emit_signal("no_stamina")
	else:
		emit_signal("have_stamina")
