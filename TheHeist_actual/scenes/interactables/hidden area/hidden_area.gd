extends Area2D

signal hiding_area_entered
signal hiding_area_exited

func _ready():
	var scene_name = get_tree().get_current_scene().get_name()
	if scene_name == "environment_testing":
		$Village.hide()
	else:
		var number = scene_name.split('_')
		if int(number[1]) > 4:
			$Village.hide()
		else:
			$Underground.hide()

func _on_body_entered(_body):
	emit_signal('hiding_area_entered')

func _on_body_exited(body):
	emit_signal('hiding_area_exited')

