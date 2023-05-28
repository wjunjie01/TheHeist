extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("active")
			await $AnimationPlayer.current_animation_length
		else:
			$AnimationPlayer.play("idle")

