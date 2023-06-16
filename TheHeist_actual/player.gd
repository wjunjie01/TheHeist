class_name Player_Class
extends CharacterBody2D


const SPEED = 300.0
#const CHAIN_PULL = 80
#signal grapple_hook
#var spring = -1050

@onready var animation_tree : AnimationTree = $AnimationTree

var can_hide = false
var can_attack = true
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
	ATTACK,
	DEAD,
	HIDE
}
var current_state = IDLE
@export var hook_speed : float = 1200
var isMouseButtonPressed = false

var left = false
var screen_size = Vector2.ZERO
var map_bounds = Rect2(Vector2(-200,-200), Vector2(2120.0, 1280.0))

@onready var ray:= $Pointer/RayCast2D
@onready var enemy_detector = $EnemyDetector

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

var has_trap = false
var bear_trap = preload ("res://bear_trap.tscn")

func _ready():
	$invinsible_icon.hide()
	animation_tree.active = true
	gravity = (2 * JumpHeight) / pow(TimeToJumpPeak, 2)
	JUMPSPEED = gravity * TimeToJumpPeak
	screen_size = get_viewport_rect().size
	#Connect signal
	grapplingHook.S_On_Hook_Reached.connect(On_Hooked)

func On_Hooked():
	grapplingHook.m_HookStay = true
	current_state = HOOKED
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and ray_free_obstacles(): #Left mouse button is clicked
				current_state = HOOKING
				grapplingHook.Activate(targetHookNode.global_position)


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
			grapplingHook.m_HookNode.global_position = grapplingHook.m_TargetPos
			pass
		ATTACK:
			pass
		DEAD:
			$CollisionShape2D.disabled = true
		HIDE:
			pass

func _physics_process(delta):
	if !map_bounds.has_point(position): #method provided by Rect2 class
		gameover()
	print(current_state)
	match current_state:
		IDLE:
			direction = Input.get_axis("move_left", "move_right")
			if (direction < 0 and enemy_detector.scale.x > 0) or (direction > 0 and enemy_detector.scale.x < 0):
				enemy_detector.scale.x *= -1
				
			if not is_on_floor(): # When floating down
				can_attack = false
				velocity.y += gravity * delta
				
			if is_on_floor():
				can_attack = true
				can_jump = true
			elif can_jump == true and $CoyoteTimer.is_stopped():
				$CoyoteTimer.start(coyote_time)
			
			if can_hide and Input.is_action_just_pressed("hide"):
				current_state = HIDE
				animation_tree['parameters/conditions/idle'] = false
				animation_tree['parameters/conditions/hide'] = true
				
			elif can_attack and Input.is_action_just_pressed("attack"):
				current_state = ATTACK
				animation_tree['parameters/conditions/idle'] = false
				animation_tree['parameters/conditions/attack'] = true
				enemy_detector.monitoring = true
			# Handle Jump.
			elif can_jump and Input.is_action_just_pressed("jump"):
				animation_tree['parameters/conditions/run'] = false
				animation_tree['parameters/conditions/idle'] = false
				animation_tree['parameters/conditions/jump'] = true
				$Jump.play()
				velocity.y = -JUMPSPEED #JUMP_VELOCITY 
			
			elif has_trap and Input.is_action_just_pressed("utilise"):
				var trap = bear_trap.instantiate()
				get_tree().get_root().add_child(trap)
				trap.position = $Trap_location.global_position
				has_trap = false
				trap.laid = true
				
			else:
				if direction: 
					velocity.x = direction * SPEED
					if direction < 0: $Spritesheet.flip_h = true
					else: $Spritesheet.flip_h = false
					if animation_tree['parameters/conditions/jump'] == true:
						pass
					else:
						animation_tree['parameters/conditions/run'] = true
						animation_tree['parameters/conditions/idle'] = false
				else: 
					velocity.x = 0
					animation_tree['parameters/conditions/run'] = false
					animation_tree['parameters/conditions/idle'] = true
			move_and_slide()
		

			
		STUCK_ON_HOOK:
			direction = Input.get_axis("move_left", "move_right")
			#$AnimatedSprite2D.stop() #STOPS The animation temporary, add the hanging from hook_point animation next time
			#If A or D is pressed, disengage
			if direction != 0:
				current_state = IDLE
			velocity.y = 0
				
		ATTACK:
			pass
		
		DEAD:
			pass
			
		HIDE:
			if Input.is_action_just_pressed('hide'):
				animation_tree['parameters/conditions/hide'] = false
				animation_tree['parameters/conditions/unhide'] = true
				

func rotate_pointer():
		var local_mouse = get_local_mouse_position() 
		var temp = rad_to_deg(atan2(local_mouse.x, local_mouse.y))
		$Pointer.rotation_degrees = -temp + 90

func ray_free_obstacles() -> bool:
	var colliding_with_hook = ray.is_colliding() and ray.get_collider() is Area2D
	if colliding_with_hook and ray.get_collider().is_in_group("hook_point") and ray.get_collider().mouseInside:
		targetHookNode = ray.get_collider()
		return true
	return false
	
func _on_coyote_timer_timeout():
	can_jump = false
	pass # Replace with function body.

signal game_over

func _on_melee_enemy_player_hit():
	gameover()
	
func gameover():
	current_state = DEAD
	animation_tree['parameters/conditions/dead'] = true

func _on_enemy_detector_body_entered(body):
	if body.is_in_group("enemy"):
		if (body.direction.x > 0 and not $Spritesheet.flip_h) or (body.direction.x < 0 and $Spritesheet.flip_h):
			body.is_dead = true

func _on_hidden_area_can_hide():
	can_hide = true


func _on_animation_finished(anim_name):
	if anim_name == "ATTACK":
		current_state = IDLE
		animation_tree['parameters/conditions/attack'] = false
		animation_tree['parameters/conditions/idle'] = true
		enemy_detector.monitoring = false
		
	elif anim_name == "UNHIDE":
		current_state = IDLE
		animation_tree['parameters/conditions/unhide'] = false
		animation_tree['parameters/conditions/idle'] = true
		
	elif anim_name == "JUMP":
		animation_tree['parameters/conditions/jump'] = false
		animation_tree['parameters/conditions/idle'] = true
		
	elif anim_name == "DIE":
		emit_signal('game_over')
	
