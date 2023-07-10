extends CharacterBody2D

@onready var CheckLeft = $CheckLeft
@onready var CheckRight = $CheckRight

const SPEED = 150.0

var direction = Vector2.RIGHT
var is_stopped = false
var gravity = Vector2(0,400)

signal player_hit

func move():
	#When cart collides with wall
	var found_wall = is_on_wall()
	#var found_obstacle = CheckLeft.is_colliding() or CheckRight.is_colliding()
	if found_wall:
		direction.x *= -1
		velocity.x = 0
		$AnimationPlayer.stop()
		if not is_stopped:
			is_stopped = true
			await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("cart_move")
		is_stopped = false
		
	velocity.x = direction.x * SPEED
	$Sprite2D.flip_h = direction.x < 0
	

func _physics_process(delta):
	move()
	velocity += gravity * delta
	move_and_slide()
	
func _on_area_2d_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		emit_signal("player_hit")
	
