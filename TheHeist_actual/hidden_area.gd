extends Area2D

signal hiding_area_entered
signal hiding_area_exited

func _on_body_entered(body):
	if body.is_in_group("player"):
		print('hello')
		emit_signal('hiding_area_entered')

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal('hiding_area_exited')

