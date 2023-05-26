extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft

var direction = Vector2.RIGHT
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	$AnimatedSprite2D.play("Walk")
	
	
	var found_wall = is_on_wall()
	if found_wall:
		print ("found wall")
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())
	if found_ledge:
		print ("found ledge")
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found

	if found_wall or found_ledge:
		direction *= -1
	velocity.x = direction.x * 100
		
	$AnimatedSprite2D.flip_h = direction.x < 0
	move_and_slide()


