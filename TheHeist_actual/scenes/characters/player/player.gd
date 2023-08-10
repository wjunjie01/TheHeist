class_name Player_Class
extends CharacterBody2D

const SPEED = 300.0

@onready var animation_tree : AnimationTree = $CharacterAnimationTree
@onready var player_collision = $CollisionShape2D
@onready var ray = $Rotation/Projectile_indicator
@onready var enemy_detector = $EnemyDetector
@onready var coyote_timer = $CoyoteTimer

var once = true
var attack_in_progress = false
var can_hide = false
var can_jump = true

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

var left = false
var screen_size = Vector2.ZERO
var map_bounds = Rect2(Vector2(-200,-200), Vector2(2120.0, 1280.0))

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Input.get_axis("move_left", "move_right")
var chain_velocity := Vector2.ZERO

var has_trap = false
var trap_scene = preload ("res://scenes/interactables/bear trap/bear_trap.tscn")

var has_shuriken = false
var shuriken_scene = preload ("res://scenes/interactables/shuriken/shuriken.tscn")


func _ready():
	$R.visible = false
	animation_tree.active = true
	gravity = (2 * JumpHeight) / pow(TimeToJumpPeak, 2)
	JUMPSPEED = gravity * TimeToJumpPeak
	screen_size = get_viewport_rect().size
	#Connect signal
	grapplingHook.S_On_Hook_Reached.connect(On_Hooked)
	
	if get_parent().has_node("hiding_areas"):
		var areas = get_parent().get_node("hiding_areas")
		for area in areas.get_children():
			area.hiding_area_entered.connect(_on_hiding_area_entered)
			area.hiding_area_exited.connect(_on_hiding_area_exited)
			

func On_Hooked():
	grapplingHook.m_HookStay = true
	current_state = HOOKED


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
	$Rotation.look_at(get_global_mouse_position())
	position.x = clamp(position.x, 0, screen_size.x)

	#Items indicator on player
	if has_shuriken:
		$Shuriken.show()
		$BearTrap.hide()
	elif has_trap:
		$Shuriken.hide()
		$BearTrap.show()
	else:
		$Shuriken.hide()
		$BearTrap.hide()
		
	if is_on_floor(): can_jump = true
	match current_state:
		HOOKED:
			hook(delta)
			grapplingHook.m_HookNode.global_position = grapplingHook.m_TargetPos
		HIDE:
			$R.visible = true
			$R/RAnimationPlayer.play("R pressed")
			
		STUCK_ON_HOOK:
			animation_tree['parameters/conditions/run'] = false
			animation_tree['parameters/conditions/idle'] = true


func _physics_process(delta):
	if !map_bounds.has_point(position): #method provided by Rect2 class
		gameover()

	if current_state == DEAD:
		animation_tree['parameters/conditions/dead'] = true
		move_and_slide()
		if not is_on_floor() and $CollisionShape2D.disabled == false:
			velocity.y += gravity * delta
		else:
			$CollisionShape2D.disabled = true
			velocity = Vector2.ZERO
	
	elif Input.is_action_just_pressed("Hook") and current_state != HIDE and ray_free_obstacles():
		current_state = HOOKING
		grapplingHook.Activate(targetHookNode.global_position)
		ray.enabled = false
		
	else:
		match current_state:
			IDLE:
				direction = Input.get_axis("move_left", "move_right")
				if (direction < 0 and enemy_detector.scale.x > 0) or (direction > 0 and enemy_detector.scale.x < 0):
					enemy_detector.scale.x *= -1
				
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
					
				if is_on_floor() or coyote_timer.time_left > 0.0:
					if Input.is_action_just_pressed("jump") and can_jump:
						animation_tree['parameters/conditions/run'] = false
						animation_tree['parameters/conditions/idle'] = false
						animation_tree['parameters/conditions/jump'] = true
						$Jump.play()
						velocity.y = -JUMPSPEED #JUMP_VELOCITY 
						
					if Input.is_action_just_pressed("attack"):
						animation_tree['parameters/conditions/idle'] = false
						animation_tree['parameters/conditions/attack'] = true
						attack_in_progress = true
						$Attack.play()
						$AttackTimer.start()
						current_state = ATTACK
						
					elif can_hide and Input.is_action_just_pressed("hide"):
						current_state = HIDE
						player_collision.disabled = true
						animation_tree['parameters/conditions/idle'] = false
						animation_tree['parameters/conditions/hide'] = true
					
					elif Input.is_action_just_pressed("utilise"):
						if has_trap:
							var trap = trap_scene.instantiate()
							get_parent().add_child(trap)
							trap.position = $Trap_location.global_position
							has_trap = false
							trap.laid = true
							
						elif has_shuriken:
							var shuriken = shuriken_scene.instantiate()
							shuriken.fired = true
							shuriken.set_collision_mask_value(2, false)
							get_parent().add_child(shuriken)
							shuriken.position = $Rotation/Shuriken_spawn.global_position
							shuriken.velocity = get_global_mouse_position() - shuriken.position
							has_shuriken = false
				if not is_on_floor(): # When floating down
					velocity.y += gravity * delta
					pass
				#check if the character is on floor before moving
				var was_on_floor = is_on_floor()
				move_and_slide()
				#were on the floor before and now it is not on the floor, either going down
				#so that it doesnt double jump
				var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
				if just_left_floor:
					coyote_timer.start()
					
			STUCK_ON_HOOK:
				direction = Input.get_axis("move_left", "move_right")
				#$AnimatedSprite2D.stop() #STOPS The animation temporary, add the hanging from hook_point animation next time
				#If A or D is pressed, disengage
				if direction:
					current_state = IDLE
				velocity.y = 0
				ray.enabled = true
					
			ATTACK:
				if attack_in_progress:
					pass
			
				else:
					animation_tree['parameters/conditions/attack'] = false
					animation_tree['parameters/conditions/idle'] = true
					current_state = IDLE
				
			HIDE:
				velocity.x = 0
				if Input.is_action_just_pressed('hide'):
					animation_tree['parameters/conditions/hide'] = false
					animation_tree['parameters/conditions/unhide'] = true

func ray_free_obstacles() -> bool:
	var colliding_with_hook = ray.is_colliding() and ray.get_collider() is Area2D
	if colliding_with_hook and ray.get_collider().is_in_group("hook_point") and ray.get_collider().mouseInside:
		targetHookNode = ray.get_collider()
		return true
	return false

signal game_over
	
func gameover():
	if once == true:
		once = false
		Engine.time_scale = 1
		current_state = DEAD
	

func _on_player_contact():
	
	gameover()


func _on_enemy_detector_body_entered(body):
	if body.is_in_group("enemy"):
		if (body.direction.x > 0 and not $Spritesheet.flip_h) or (body.direction.x < 0 and $Spritesheet.flip_h):
			body.is_dead = true
	elif body.is_in_group("boss"):
		if (body.direction.x > 0 and not $Spritesheet.flip_h) or (body.direction.x < 0 and $Spritesheet.flip_h):
			body.take_damage()
			
func _on_enemy_detector_area_entered(area):
	if area.is_in_group("bullet"):
		area.deflected = true


func _on_animation_finished(anim_name):
	if current_state != DEAD:
		if anim_name == "ATTACK":
			current_state = IDLE
			animation_tree['parameters/conditions/attack'] = false
			animation_tree['parameters/conditions/idle'] = true
			
		elif anim_name == "UNHIDE":
			current_state = IDLE
			animation_tree['parameters/conditions/unhide'] = false
			animation_tree['parameters/conditions/idle'] = true
			player_collision.disabled = false
			
		elif anim_name == "JUMP":
			animation_tree['parameters/conditions/jump'] = false
			animation_tree['parameters/conditions/idle'] = true
			
	if anim_name == "DIE":
		emit_signal("game_over")
		
		
func _on_attack_timer_timeout():
	attack_in_progress = false

func _on_hiding_area_entered():
	can_hide = true
	$R.visible = true
	$R/RAnimationPlayer.play("R pressed")

func _on_hiding_area_exited():
	can_hide = false
	$R.visible = false
	$R/RAnimationPlayer.stop()
