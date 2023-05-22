extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction = Input.get_axis("move_left", "move_right")


func _physics_process(delta):

	direction = Input.get_axis("move_left", "move_right")
	animation_locked = false
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("jump")
		if direction < 0: $AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
		animation_locked = true

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$AnimatedSprite2D.play("jump")
		animation_locked = true
		velocity.y = JUMP_VELOCITY

	if direction: velocity.x = direction * SPEED
	else: velocity.x = 0

		
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
