extends Area2D

signal player_hit

func _on_body_entered(body): #any time any physics body enter the spike, this function will execute
	if body.name == "Player": get_tree().get_first_node_in_group('player').gameover()

