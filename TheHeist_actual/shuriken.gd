extends Area2D

var velocity = Vector2.ZERO
var speed = 20
var fired = false

func _physics_process(_delta):
	if fired:
		set_collision_mask_value(4, true)
		set_collision_mask_value(2, false)
	position += velocity.normalized() * speed
	if velocity != Vector2.ZERO:
		$Sprite2D.rotation += 30


func _on_body_entered(body):
	if !fired and body.is_in_group("player"):
		body.has_shuriken = true
		body.has_trap = false
		
	
	elif fired and body.is_in_group("enemy"):
		body.is_dead = true
	
	elif fired and body.is_in_group("drones"):
		body.is_destroyed = true
	queue_free()
