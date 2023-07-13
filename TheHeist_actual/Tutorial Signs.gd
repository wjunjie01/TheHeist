extends Area2D

func _on_body_entered(_body):
	$Text.show()

func _on_body_exited(_body):
	$Text.hide()
