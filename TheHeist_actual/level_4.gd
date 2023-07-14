extends Node2D

func _ready():
	$Tanjiro.play()
	
func _on_player_game_over():
	$Tanjiro.stop()
