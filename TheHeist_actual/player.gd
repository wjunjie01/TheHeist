extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CHAIN_PULL = 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed: #Left mouse button is clicked
			var globalMousePos = get_viewport().get_mouse_position()
			var localMousePos = self.to_local(globalMousePos)
			$Chain.shoot(localMousePos)
			#mouse position relative to the centre of the screen
		else:
			$Chain.release()



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

#Hook 
	if $Chain.hooked:
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			chain_velocity.y *= 0.55
		else:
			chain_velocity.y *= 1.2
		
		if sign(chain_velocity.x) != sign(direction):
			chain_velocity.x *= .7
	else:
		chain_velocity = Vector2.ZERO
	velocity += chain_velocity
		
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
