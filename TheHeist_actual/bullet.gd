extends Area2D

var SPEED = 300
var velocity = Vector2.ZERO
var deflected = false

func _physics_process(delta):
	if deflected:
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, true)
		
	if (velocity.x < 0 and scale.x > 0) or (velocity.x > 0 and scale.x < 0):
		scale.x *= -1
		


	position += SPEED * delta * velocity.normalized()
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.gameover()
		
	if body.is_in_group("enemy"):
		body.is_dead = true
	queue_free()
