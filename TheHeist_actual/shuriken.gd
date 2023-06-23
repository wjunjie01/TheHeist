extends Area2D

var velocity = Vector2.ZERO
var speed = 20
var fired = false

func _physics_process(delta):
	position += velocity.normalized() * speed
	if velocity != Vector2.ZERO:
		$Sprite2D.rotation += 30


func _on_body_entered(body):
	if !fired and body.is_in_group("player"):
		body.has_shuriken = true
		body.has_trap = false
		queue_free()
	
	elif fired and body.is_in_group("enemy"):
		body.is_dead = true
		queue_free()
	queue_free()
