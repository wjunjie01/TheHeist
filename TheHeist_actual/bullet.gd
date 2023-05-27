extends Area2D

var speed = 1000
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body is CharacterBody2D:
		body.queue_free()
	queue_free()
	

