extends Area2D

var laid = false
func _ready():
	$AnimationPlayer.play("Lay Trap")


func _physics_process(delta):
	pass


func _on_body_entered(body):
	if laid and body.is_in_group("enemy"):
		body.is_dead = true
		$AnimationPlayer.play("Trap")

	elif not laid and body.is_in_group("player"):
		queue_free()
		body.has_trap = true
		


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Trap":
		queue_free()
