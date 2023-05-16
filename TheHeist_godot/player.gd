extends CharacterBody2D

const GRAVITY = 800.0
const WALK_SPEED = 200.0
const JUMP = 600
#var current_rope_length
#var rope_length = 500
#var hook_pos = Vector2.ZERO
#var hooked


#func hook():
#	$Raycast.look_at(get_global_mouse_position())
#	if Input.is_action_just_pressed("left_click"):
#		hook_pos = get_hook_pos()
#		if hook_pos:
#			hooked = true
#			#global position is from player
#			current_rope_length = global_position.distance_to(hook_pos)
#
#func get_hook_pos():
#

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

