extends Node2D

func _ready():
	$Ghibli.play()
	
func _on_player_game_over():
	$Ghibli.stop()
