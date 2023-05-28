extends Area2D

var speed = 300
var direction
func _physics_process(delta):
	position += transform.x * speed * delta * direction

func _on_Bullet_body_entered(body):
	body.queue_free()
	queue_free()
