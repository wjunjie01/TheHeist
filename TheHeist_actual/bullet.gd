extends Area2D

var SPEED = 300
var direction = Vector2.RIGHT
var deflected = false:
	set(value):
		deflected = value
		if value:
			set_collision_mask_value(2, false)
			set_collision_mask_value(4, true)
			scale.x *= -1
			direction *= -1
			look_at(global_position - direction)

func _ready():
	look_at(global_position + direction)
	
func _physics_process(delta):
	position += SPEED * delta * direction.normalized()
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.gameover()
		
	if body.is_in_group("enemy"):
		body.is_dead = true
	
	if body.is_in_group("boss"):
		body.take_damage()
	queue_free()
