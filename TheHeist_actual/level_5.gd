extends Node2D

func _ready():
	$"Dua Lipa".play()

func _on_player_game_over():
	$"Dua Lipa".stop()
