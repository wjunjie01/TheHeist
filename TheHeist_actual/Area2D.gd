extends Area2D

var entered = false

func _on_body_entered(body):
	entered = true
	
func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file('res://level_2.tscn')
