extends Node2D

var can_jump = true
signal cannot_jump

func _ready():
	$zelda.play()

func _on_player_game_over():
	$zelda.stop()

func _on_spring_cannot_jump():
	can_jump = false
	emit_signal("cannot_jump")

func _on_spring_2_cannot_jump():
	can_jump = false
	emit_signal("cannot_jump")

func _on_spring_3_cannot_jump():
	can_jump = false 
	emit_signal("cannot_jump")

func _on_spring_4_cannot_jump():
	can_jump = false 
	emit_signal("cannot_jump")



