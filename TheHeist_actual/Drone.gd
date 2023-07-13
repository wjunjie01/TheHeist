extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
enum { scan_idle, scan_walk, stationary, destroyed }
var current_state = scan_idle
var rng = RandomNumberGenerator.new()
var direction = Vector2.RIGHT
var SPEED = 100
var is_destroyed = false

func _physics_process(delta):
	if is_destroyed:
		$PlayerDetector.visible = false
		$AnimationPlayer.play("Destroyed")
		move_and_slide()
		if not is_on_floor():
			position.y += 3
		return
		
	match current_state:
		scan_idle:
			$AnimationPlayer.play("Scan_idle")
			
		scan_walk:
			var found_ledge = not ($LedgeCheckRight.is_colliding() and $LedgeCheckLeft.is_colliding())
			if found_ledge:
				direction *= -1
			
			position += direction * SPEED * delta
			$AnimationPlayer.play("Scan_walk")
			
		stationary:
			$AnimationPlayer.play("Scan_idle")
			$Timer.wait_time = 1.0

signal player_detected

func _on_area_2d_body_entered(_body):
	set_deferred("$PlayerDetector/CollisionPolygon2D.disabled", "true")
	$PlayerDetector/Polygon2D.visible = false
	current_state = stationary
	emit_signal('player_detected')


func _on_idle_timer_timeout():
	$AnimationPlayer.stop()
	$Timer.wait_time =  rng.randf_range(1.0, 3.0)
	if current_state == scan_idle:
		current_state = scan_walk
		direction *= -1
	elif current_state == scan_walk:
		current_state = scan_idle
	elif current_state == stationary:
		$PlayerDetector/CollisionPolygon2D.disabled = false
		$PlayerDetector/Polygon2D.visible = true
		current_state = scan_walk


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Destroyed":
		queue_free()
