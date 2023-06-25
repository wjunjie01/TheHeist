extends Area2D

signal hiding_area_entered
signal hiding_area_exited

func _on_body_entered(body):
	emit_signal('hiding_area_entered')

func _on_body_exited(body):
	emit_signal('hiding_area_exited')

