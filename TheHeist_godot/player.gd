extends CharacterBody2D

const GRAVITY = 100.0
const WALK_SPEED = 200.0
const JUMP = 50

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity.x = 0
	if Input.is_action_just_pressed("action_jump"):
		velocity.y -= JUMP
	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
	move_and_slide()

