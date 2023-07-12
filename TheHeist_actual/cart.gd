extends CharacterBody2D

@onready var CheckLeft = $CheckLeft
@onready var CheckRight = $CheckRight

const SPEED = 150.0

var map_bounds = Rect2(Vector2(-200,-200), Vector2(2120,1280))

var direction = Vector2.RIGHT
var is_stopped = false
var gravity = Vector2(0,400)

signal player_hit

func move():
	#When cart collides with wall
	var found_wall = is_on_wall()
	var found_obstacle = CheckLeft.is_colliding() or CheckRight.is_colliding()
	if found_wall:
		direction.x *= -1
		velocity.x = 0
		$AnimationPlayer.stop()
		if not is_stopped:
			is_stopped = true
			await get_tree().create_timer(1.0).timeout
			is_stopped = false
		$AnimationPlayer.play("cart_move")
		
	velocity.x = direction.x * SPEED
	$Sprite2D.flip_h = direction.x < 0
	

func _physics_process(delta):
	if not is_stopped: move()
	else: velocity.x = 0
	velocity += gravity * delta
	move_and_slide()
	
	#deletes the cart if it falls out of the map
	if !map_bounds.has_point(position):
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print('hit')
		body.gameover()
