extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("active")
		body.velocity.y -= 1750
		$Boing.play()
		await $AnimationPlayer.current_animation_length
