extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
enum { scan_idle, scan_walk, stationary }
var current_state = scan_idle
var rng = RandomNumberGenerator.new()
var direction = Vector2.RIGHT
var SPEED = 100

func _physics_process(delta):
	match current_state:
		scan_idle:
			$AnimationPlayer.play("Scan_idle")
			
		scan_walk:
			position += direction * SPEED * delta
			$AnimationPlayer.play("Scan_walk")
			
		stationary:
			$AnimationPlayer.play("Scan_idle")
			$PlayerDetector/CollisionPolygon2D.disabled = true
			$Timer.wait_time = 1.0
			
			

signal player_detected

func _on_area_2d_body_entered(body):
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
		current_state = scan_idle
	


