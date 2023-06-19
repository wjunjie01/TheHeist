extends Area2D

func _on_body_entered(body: PhysicsBody2D):
	$Text.show()

func _on_body_exited(body: PhysicsBody2D):
	$Text.hide()
