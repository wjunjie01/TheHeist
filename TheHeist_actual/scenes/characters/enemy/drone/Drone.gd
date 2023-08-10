extends CharacterBody2D

enum { SCAN_IDLE, SCAN_WALK, STATIONARY, DESTROYED }
var current_state = SCAN_IDLE:
	set(value):
		current_state = value
		match value:
			SCAN_IDLE:
				$AnimationPlayer.play("Scan_idle")
			SCAN_WALK:
				$AnimationPlayer.play("Scan_walk")
			STATIONARY:
				$AnimationPlayer.play("Scan_idle")
				$Timer.wait_time = 3.0
			DESTROYED:
				$AnimationPlayer.stop()
				$AnimationPlayer.play("Destroyed")
				
var rng = RandomNumberGenerator.new()
var direction = Vector2.RIGHT
var SPEED = 100
var is_destroyed = false:
	set(value):
		is_destroyed = value
		current_state = DESTROYED
		$PlayerDetector.visible = false
		$PlayerDetector.monitoring = false

var still_inside = false
var just_detected = false

func _ready():
	$ExclamationMark.visible = false
	$Timer.wait_time = 3.0

func _physics_process(delta):
	if is_destroyed:
		move_and_slide()
		if not is_on_floor():
			position.y += 3
		return
		
	match current_state:
		SCAN_IDLE:
			pass
			
		SCAN_WALK:
			var found_ledge = not ($LedgeCheckRight.is_colliding() and $LedgeCheckLeft.is_colliding())
			if found_ledge:
				direction *= -1
			
			position += direction * SPEED * delta
			
		STATIONARY:
			pass
			
signal player_detected

func _on_player_detector_body_entered(_body):
	if !just_detected:
		$Alarm.play()
		$ExclamationMark.visible = true
		$PlayerDetector.set_deferred("monitoring", false)
#		$PlayerDetector.monitoring = false
		current_state = STATIONARY
		emit_signal('player_detected')
		still_inside = true
		just_detected = true


func _on_player_detector_body_exited(_body):
	still_inside = false

func _on_idle_timer_timeout():
	if current_state == SCAN_IDLE:
		$Timer.wait_time =  rng.randf_range(1.0, 3.0)
		current_state = SCAN_WALK
		direction *= -1
	elif current_state == SCAN_WALK:
		$Timer.wait_time =  rng.randf_range(1.0, 3.0)
		current_state = SCAN_IDLE
	elif current_state == STATIONARY:
		if !still_inside:
			$Alarm.stop()
			$ExclamationMark.visible = false
			$Timer.wait_time =  rng.randf_range(1.0, 3.0)
			$PlayerDetector.monitoring = true
			current_state = SCAN_WALK
			just_detected = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Destroyed":
		queue_free()



