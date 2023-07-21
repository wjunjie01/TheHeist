extends CharacterBody2D

var health = 1
var direction = Vector2.RIGHT
const SPEED = 200
const DASH_SPEED = 500
var first_time = true

@onready var player = get_parent().get_node("Player")
@onready var playerCamera = player.get_node("PlayerCamera")
@onready var boss_drone = get_parent().get_node("boss_drone")
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Spritesheet

var current_phase = 1:
	set(value):
		current_phase = value
		if value == 2:
			boss_drone.is_destroyed = true
			
			var lamps = get_parent().get_node("lamps")
			for lamp in lamps.get_children():
				lamp.queue_free()
			var drones = get_parent().get_node("drones")
			for drone in drones.get_children():
				drone.is_destroyed = true
			
	
enum { MOVE_WITH_DRONE, DASH_ATTACK, COLLIDED, IDLE, TRACK, WALK, DEATH }

var current_state = MOVE_WITH_DRONE:
	set(value):
		current_state = value
		if value == DEATH:
			$IdleTimer.stop()
			$AttackTimer.stop()
			$TrackTimer.stop()
			animationPlayer.stop()
			animationPlayer.play("Death")
			
		elif value == IDLE:
			$AttackDetector.monitoring = false
			$IdleTimer.wait_time = 2
			$IdleTimer.start()
			animationPlayer.play("Idle")
			
		elif value == TRACK:
			$TrackTimer.start()
			
		elif value == DASH_ATTACK:
			$AttackTimer.start()
			dash_attack()
			$AttackDetector.monitoring = true
			animationPlayer.play("Run_attack")
		
		elif value == COLLIDED:
			playerCamera.apply_shake()
			velocity = Vector2.ZERO
			$AttackDetector.monitoring = false
			animationPlayer.play("Hurt")
			$IdleTimer.wait_time = 3
			$IdleTimer.start()
		
		elif value == WALK:
			animationPlayer.play("Run")

func _ready():
	animationPlayer.play("Idle")
	
func take_damage():
	if current_phase == 1:
		animationPlayer.play("Hurt")
		health -= 1
		if health == 0:
			current_phase += 1
			health = 3
			
	elif current_phase == 2 and current_state == COLLIDED:
		print('takedmg')
		animationPlayer.play("Hurt")
		health -= 1
		if health == 0:
			current_phase += 1
			current_state = DEATH

func _physics_process(delta):
	move_and_slide()
	
	if not is_on_floor():
		position.y += 10
	
	if current_phase == 1:
		sprite.flip_h = boss_drone.direction.x < 0
		
	elif current_phase == 2:
		if first_time and is_on_floor():
			current_state = IDLE
			first_time = false
			
		if current_state == DEATH or current_state == COLLIDED:
			return
		if player.current_state == 6 and current_state != DASH_ATTACK: #if player is hiding
			current_state = WALK

		match current_state:
			WALK:
				if is_on_wall():
					direction *= -1
				sprite.flip_h = direction.x < 0
				velocity = direction * SPEED
				
				if player.current_state != 6:
					current_state = TRACK
				
			IDLE:
				velocity = Vector2.ZERO
				
			TRACK:
				track()
					
			DASH_ATTACK:
				if is_on_wall():
					current_state = COLLIDED

func track():
	var player_pos = player.global_position
	if player_pos.x < global_position.x:
		direction = Vector2.LEFT
		sprite.flip_h = true
	else:
		direction = Vector2.RIGHT
		sprite.flip_h = false
		
	if abs(player_pos.x - global_position.x) < 50:
		velocity = Vector2.ZERO
		animationPlayer.play("Idle")
	else:
		velocity = direction * SPEED
		animationPlayer.play("Run")

func dash_attack():
	var player_pos = player.global_position
	var dash_dir = Vector2.RIGHT
	sprite.flip_h = false
	if player_pos.x < global_position.x:
		dash_dir = Vector2.LEFT
		sprite.flip_h = true

	velocity = dash_dir * DASH_SPEED

func _on_idle_timer_timeout():
	if current_state != WALK:
		current_state = TRACK
		
func _on_track_timer_timeout():
	current_state = DASH_ATTACK
	
func _on_attack_timer_timeout():
	if current_state == COLLIDED:
		return
	if current_state != WALK:
		current_state = IDLE

func _on_attack_detector_body_entered(body):
	body.gameover()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
