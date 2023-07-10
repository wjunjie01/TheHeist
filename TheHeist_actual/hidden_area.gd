extends Area2D

signal hiding_area_entered
signal hiding_area_exited


func _ready():
	var level = get_tree().get_current_scene().get_name()
	var array = level.split("_") #split the current into 2, [level, 2] an array
	var number = array[1].to_int()
	if number > 4:
		$Sprite2D.hide()
	else:
		$Sprite2D2.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal('hiding_area_entered')

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal('hiding_area_exited')

