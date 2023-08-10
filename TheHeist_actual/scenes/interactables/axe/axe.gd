extends Node2D

signal player_hit

func _on_area_2d_body_entered(body):
	$axe_slash.play()
	body.gameover()
