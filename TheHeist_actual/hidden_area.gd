extends Area2D

signal can_hide
signal player_exit

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal('can_hide')

