extends CharacterBody2D

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft
@onready var PlayerDetector = $PlayerDetector
@onready var Muzzle = $Muzzle
var bullet_scene = preload("res://bullet.tscn")
var direction = Vector2.RIGHT
var can_shoot = true;

#func dead():
#	$AnimatedSprite2D.play("Hurt + Death")
#	$CollisionShape2D.set_deferred("disabled", true)
	
func shoot():

	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.transform = $Muzzle.transform
#	var player_pos = PlayerDetector.get_collider().get_global_position()
#	var distance = player_pos - self.get_global_position()

#func _process(delta):
#	$AnimatedSprite2D.play("Walk")
#	if PlayerDetector.is_colliding() and can_shoot:
#		$AnimatedSprite2D.stop()
#		$AnimatedSprite2D.play("Walk")
		

func _physics_process(_delta):
	$AnimatedSprite2D.play("Walk")
	var found_wall = is_on_wall()
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found

	if found_wall or found_ledge:
		direction *= -1
		var curr_detector_pos = PlayerDetector.get_target_position()
		PlayerDetector.set_target_position(curr_detector_pos * -1)
#		var curr_muzzle_pos = Muzzle.get_target_position()
#		Muzzle.set_target_position(curr_muzzle_pos * -1)
				
	velocity.x = direction.x * 100
	if PlayerDetector.is_colliding() and can_shoot:
		shoot()
		can_shoot = false
		
	$AnimatedSprite2D.flip_h = direction.x < 0
	move_and_slide()
	
func _on_timer_timeout():
	can_shoot = true

