extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
const CHAIN_PULL = 80
signal grapple_hook
var spring = -1050

#Coyote_time
var coyote_time = 0.3
var can_jump = false

#Jump velocity = Gravity * time to jumppeak
@export var TimeToJumpPeak = .25
@export var JumpHeight: int = 128 #in pixels
var gravity: float
var JUMPSPEED: float

enum{
	IDLE,
	HOOKING, 
	HOOKED
}
var current_state = IDLE
var hook_speed = 5
var isMouseButtonPressed = false

@onready var ray:= $Pointer/RayCast2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

func _ready():
	gravity = (2 * JumpHeight) / pow(TimeToJumpPeak, 2)
	JUMPSPEED = gravity * TimeToJumpPeak

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		if event.pressed: #Left mouse button is clicked
#			var globalMousePos = get_aviewport().get_mouse_position()
#			var localMousePos = self.to_local(globalMousePos)
#			$Chain.shoot(localMousePos)
#			#mouse position relative to the centre of the screen
#		else:
#			$Chain.release()
#
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and ray_free_obstacles(): #Left mouse button is clicked
				current_state = HOOKING



func _process(delta):
	rotate_pointer()
	match current_state:
		IDLE:
			pass
		HOOKING:
			hook(delta)
		HOOKED:
			pass
#			position = hook_point


func hook(delta):
	var hook_direction = get_local_mouse_position()
	position.x += hook_direction.x * hook_speed * delta
	position.y += hook_direction.y * hook_speed * delta


func _physics_process(delta):
	direction = Input.get_axis("move_left", "move_right")
	animation_locked = false
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("jump")
		if direction < 0: $AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
		animation_locked = true

	if is_on_floor() and can_jump == false:
		can_jump = true
	elif can_jump == true and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyote_time)

	# Handle Jump.
	if can_jump and Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump")
		animation_locked = true
		velocity.y = -JUMPSPEED #JUMP_VELOCITY 

	if direction: velocity.x = direction * SPEED
	else: velocity.x = 0
#
		
#old hook
#	if $Chain.hooked:
#		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
#		if chain_velocity.y > 0:
#			chain_velocity.y *= .7
#		else:
#			chain_velocity.y *= 1
#
#		if sign(chain_velocity.x) != sign(direction):
#			chain_velocity.x *= .7
#	else:
#		chain_velocity = Vector2.ZERO
#	velocity += chain_velocity
		
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
		if Input.is_action_just_pressed("attack"):
			$AnimatedSprite2D.play("attack")
			

func _on_stamina_bar_no_stamina():
	$Chain.release()


func _on_spring_body_entered(_body):
	velocity.y = spring
	
func rotate_pointer():
		var local_mouse = get_local_mouse_position() 
		var temp = rad_to_deg(atan2(local_mouse.x, local_mouse.y))
		$Pointer.rotation_degrees = -temp + 90

func ray_free_obstacles() -> bool:
	var colliding_with_hook = ray.is_colliding() and ray.get_collider() is Area2D
	if colliding_with_hook and ray.get_collider().is_in_group("hook_point"):
		return true
	return false
	
	
#	var result = !ray.is_colliding() #returns true no obstacles OR if there are no obstacles blocking hook point
#	if result:
#		if ray.get_collider() is Area2D:
#			if ray.get_collider().is_in_group("hook_point"):
#				return true
#	return false

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
#			isMouseButtonPressed = true
#			print("pressed")
#		else:
#			isMouseButtonPressed = false

func _on_hook_point_body_entered(body):
	current_state = HOOKED



#func _on_hook_point_mouse_entered():
#	if isMouseButtonPressed:
#		print("PRESSED AND ENTERED")
#		current_state = HOOKING
	


func _on_coyote_timer_timeout():
	can_jump = false
	pass # Replace with function body.
