extends Area2D

var laid = false

func _ready():
	$AnimationPlayer.play("Lay Trap")

func _on_body_entered(body):
	if laid and body.is_in_group("enemy"):
		body.is_dead = true
		$AnimationPlayer.play("Trap")

	elif not laid and body.is_in_group("player"):
		queue_free()
		body.has_trap = true  
		body.has_shuriken = false

	
