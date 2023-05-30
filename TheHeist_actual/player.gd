extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
const CHAIN_PULL = 80
signal grapple_hook
var spring = -1050

#Jump velocity = Gravity * time to jumppeak
@export var TimeToJumpPeak = .25
@export var JumpHeight: int = 128 #in pixels
var gravity: float
var JUMPSPEED: float


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

func _ready():
	gravity = (2 * JumpHeight) / pow(TimeToJumpPeak, 2)
	JUMPSPEED = gravity * TimeToJumpPeak

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed: #Left mouse button is clicked
			var globalMousePos = get_viewport().get_mouse_position()
			var localMousePos = self.to_local(globalMousePos)
			$Chain.shoot(localMousePos)
			#mouse position relative to the centre of the screen
		else:
			$Chain.release()


func _process(delta):
	rotate_pointer()

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
		velocity.y = -JUMPSPEED #JUMP_VELOCITY 

	if direction: velocity.x = direction * SPEED
	else: velocity.x = 0

	if ray_free_obstacles():
		print("Free to hook")
		
	else:
		print("Obstacles in the way")
		
		
#Hook 
	if $Chain.hooked:
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			chain_velocity.y *= .7
		else:
			chain_velocity.y *= 1
		
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

func _on_stamina_bar_no_stamina():
	$Chain.release()


func _on_spring_body_entered(_body):
	velocity.y = spring
	
func rotate_pointer():
		var local_mouse = get_local_mouse_position() 
		var temp = rad_to_deg(atan2(local_mouse.x, local_mouse.y))
		$Pointer.rotation_degrees = -temp + 90

func ray_free_obstacles() -> bool:
	var result = !$Pointer/RayCast2D.is_colliding()
#	if result and $Pointer/RayCast2D.get_collider().name == "hook_point":
#		return true
	return result
