extends Area2D

var speed = 700
var direction
func _physics_process(delta):
	position += transform.x * speed * delta * direction

func _on_Bullet_body_entered(body):
	get_tree().reload_current_scene()
	
