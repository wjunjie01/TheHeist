extends Node2D

func _ready():
	$zelda.play()

func _on_player_game_over():
	$zelda.stop()
