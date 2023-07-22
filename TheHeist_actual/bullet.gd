extends Area2D

var SPEED = 300
var velocity = Vector2.ZERO
var deflected = false:
	set(value):
		deflected = value
		if value:
			set_collision_mask_value(2, false)
			set_collision_mask_value(4, true)
			scale.x *= -1
			velocity *= -1
			look_at(position - velocity)

func _physics_process(delta):
	if !deflected:
		look_at(position + velocity)
	position += SPEED * delta * velocity.normalized()
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.gameover()
		
	if body.is_in_group("enemy"):
		body.is_dead = true
	queue_free()
