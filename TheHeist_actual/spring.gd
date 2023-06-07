extends Area2D


func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("active")
			body.velocity.y -= 850
			get_tree()
			await $AnimationPlayer.current_animation_length
		else:
			$AnimationPlayer.play("idle")

