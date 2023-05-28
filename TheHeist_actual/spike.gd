extends Area2D

func _on_body_entered(body): #any time any physics body enter the spike, this function will execute
	if body.name == "Player": get_tree().reload_current_scene()

