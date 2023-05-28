extends CharacterBody2D

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft
@onready var PlayerDetector = $PlayerDetector
@onready var MuzzleRight = $"Muzzle Right"
@onready var MuzzleLeft = $"Muzzle Left"

var bullet_scene = preload("res://bullet.tscn")
var direction = Vector2.RIGHT
var can_shoot = true
var curr_muzzle = MuzzleRight


#func dead():
#	$AnimatedSprite2D.play("Hurt + Death")
#	$CollisionShape2D.set_deferred("disabled", true)
	
func shoot(muzzle, dir):

	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.direction = dir
	if dir.x == -1:
		bullet.get_node("BulletArt").flip_h = true
	else:
		bullet.get_node("BulletArt").flip_h = false
	bullet.position = muzzle.position
	
	

	
#	var player_pos = PlayerDetector.get_collider().get_global_position()
#	var distance = player_pos - self.get_global_position()

		

func _physics_process(_delta):
	$AnimatedSprite2D.play("Walk")
	var found_wall = is_on_wall()
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())

	# Change direction if reach a ledge or wall
	if found_wall or found_ledge:
		direction *= -1
		var curr_detector_pos = PlayerDetector.get_target_position()
		PlayerDetector.set_target_position(curr_detector_pos * -1)
		if curr_muzzle == MuzzleRight:
			curr_muzzle = MuzzleLeft
		else:
			curr_muzzle = MuzzleRight

				
	velocity.x = direction.x * 100
	if PlayerDetector.is_colliding() and can_shoot:
		shoot(curr_muzzle, direction)
		can_shoot = false
		
	$AnimatedSprite2D.flip_h = direction.x < 0
	move_and_slide()
	
func _on_timer_timeout():
	can_shoot = true

