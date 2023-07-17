extends Node2D

var can_jump = true
signal cannot_jump

func _ready():
	$zelda.play()

func _on_player_game_over():
	$zelda.stop()
