class_name Player_Class
extends CharacterBody2D


const SPEED = 300.0
#const CHAIN_PULL = 80
#signal grapple_hook
#var spring = -1050

#Coyote_time
var coyote_time = 0.3
var can_jump = false

#Jump velocity = Gravity * time to jumppeak
@export var TimeToJumpPeak = .2
@export var JumpHeight: int = 120 #in pixels
var gravity: float
var JUMPSPEED: float

#Hook
var targetHookNode : HookPoint_Class = null
@export var hookReachOffset : float = 10.0

@export var grapplingHook : GrapplingHook_Class

enum{
	IDLE,
	HOOKING, 
	HOOKED,
	STUCK_ON_HOOK,
	ATTACK
}
var current_state = IDLE
@export var hook_speed : float = 1200
var isMouseButtonPressed = false


var screen_size = Vector2.ZERO
var map_bounds = Rect2(0.0,0.0,1920.0, 1080.0)

@onready var ray:= $Pointer/RayCast2D
@onready var enemy_detector = $EnemyDetector

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

func _ready():
	gravity = (2 * JumpHeight) / pow(TimeToJumpPeak, 2)
	JUMPSPEED = gravity * TimeToJumpPeak
	screen_size = get_viewport_rect().size
	#Connect signal
	grapplingHook.S_On_Hook_Reached.connect(On_Hooked)

func On_Hooked():
	current_state = HOOKED
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and ray_free_obstacles(): #Left mouse button is clicked
				current_state = HOOKING
				grapplingHook.Activate(targetHookNode.global_position)


func _process(delta):
	rotate_pointer()
	position.x = clamp(position.x, 0, screen_size.x)
	
	match current_state:
		IDLE:
			pass
		HOOKING:
			pass
		HOOKED:
			hook(delta)
#			position = hook_point
			pass
		ATTACK:
			pass


func hook(delta):
	var hook_direction = (targetHookNode.GetTargetedPosition() - global_position).normalized()
	position.x += hook_direction.x * hook_speed * delta
	position.y += hook_direction.y * hook_speed * delta
	
	#If position is reached, switch to idle
	var dist : float = (targetHookNode.GetTargetedPosition() - global_position).length()
	if dist <= hookReachOffset:
		if targetHookNode.hookType == HookPoint_Class.HOOKTYPE.UNSTICKY:
			current_state = IDLE
		else:
			current_state = STUCK_ON_HOOK
		
		grapplingHook.Deactivate()
		pass


func _physics_process(delta):
	if !map_bounds.has_point(position): #method provided by Rect2 class
		gameover()
	
	match current_state:
		IDLE:
			direction = Input.get_axis("move_left", "move_right")
			if (direction < 0 and enemy_detector.scale.x > 0) or (direction > 0 and enemy_detector.scale.x < 0):
				enemy_detector.scale.x *= -1
				
			animation_locked = false
			if not is_on_floor():
				velocity.y += gravity * delta
				$AnimatedSprite2D.play("jump")
				if direction < 0: 
					$AnimatedSprite2D.flip_h = true
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
			
			# Handle Attack.
			elif Input.is_action_just_pressed("attack"):
				current_state = ATTACK
				$AnimatedSprite2D.play("attack")
				animation_locked = true
			

			if direction: velocity.x = direction * SPEED
			else: velocity.x = 0
			
			update_animation()
			move_and_slide()
			
			
		STUCK_ON_HOOK:
			direction = Input.get_axis("move_left", "move_right")
			$AnimatedSprite2D.stop() #STOPS The animation temporary, add the hanging from hook_point animation next time
			#If A or D is pressed, disengage
			if direction != 0:
				current_state = IDLE
				
		ATTACK:
			enemy_detector.monitoring = true
			


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
			
			
#
#func _on_stamina_bar_no_stamina():
#	$Chain.release()

#func collide_with_spring() -> bool:
#	var bodies = get_overlapping_bodies()
#	for body in bodies:
#		if body.group == "SPRING":
#			return true
#		return false
	
func rotate_pointer():
		var local_mouse = get_local_mouse_position() 
		var temp = rad_to_deg(atan2(local_mouse.x, local_mouse.y))
		$Pointer.rotation_degrees = -temp + 90

func ray_free_obstacles() -> bool:
	var colliding_with_hook = ray.is_colliding() and ray.get_collider() is Area2D
	if colliding_with_hook and ray.get_collider().is_in_group("hook_point"):
		targetHookNode = ray.get_collider()
		return true
	return false
	
func _on_coyote_timer_timeout():
	can_jump = false
	pass # Replace with function body.

signal game_over

func _on_melee_enemy_player_hit():
	emit_signal('game_over')
	queue_free()
	
func gameover():
	emit_signal('game_over')
	queue_free()

func _on_enemy_detector_body_entered(body):
	if body.is_in_group("enemy"):
		if (body.direction.x > 0 and direction > 0) or (body.direction.x < 0 and direction < 0):
			body.is_dead = true

func _on_animated_sprite_2d_animation_finished():
	current_state = IDLE
	enemy_detector.monitoring = false
	
	
