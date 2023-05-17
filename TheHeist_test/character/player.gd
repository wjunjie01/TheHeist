extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction
var screen_size = Vector2.ZERO
var animation_locked : bool = false #if == true an animation is playing 

func _ready():
	screen_size = get_viewport_rect().size 

func _physics_process(delta):
	# Get the input direction and returns a float +ve if right -ve if left
	direction = Input.get_axis("move_left", "move_right")
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	#reset animation locked each frame
	animation_locked = false
	#add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("jump_air")
		if direction < 0: $AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
		animation_locked = true

	# Handle Jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump_air")
		animation_locked = true

	if direction: #if there is a number
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	
	update_animation()
	move_and_slide()
	
func update_animation():
	if animation_locked == false:
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("run")
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("run")
		if direction == 0 and is_on_floor():
			$AnimatedSprite2D.play("idle")

