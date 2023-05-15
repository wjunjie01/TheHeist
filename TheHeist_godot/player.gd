extends CharacterBody2D

const GRAVITY = 800.0
const WALK_SPEED = 200.0
const JUMP = 600

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity.x = 0
	#expression return a boolean expression
	var is_falling = velocity.y > 0.0 and not is_on_floor()
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y -= JUMP
	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
	move_and_slide()

