extends Area2D

signal hiding_area_entered
signal hiding_area_exited

func _ready():
	var scene_name = get_tree().get_current_scene().get_name()
	var number = scene_name.split('_')
	if int(number[1]) > 4:
		$Village.hide()
	else:
		$Underground.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal('hiding_area_entered')

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal('hiding_area_exited')

