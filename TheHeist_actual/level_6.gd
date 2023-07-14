extends Node2D

func _ready():
	$Queen.play()
	


func _on_player_game_over():
	$Queen.stop()
