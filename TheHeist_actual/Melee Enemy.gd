extends CharacterBody2D

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft
const SPEED = 100.0

var direction = Vector2.RIGHT

func _ready():
	$AnimatedSprite2D.play("Walk")
	
func _physics_process(delta):
	var found_wall = is_on_wall()
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())

	# Change direction if reach a ledge or wall
	if found_wall or found_ledge:
		direction *= -1

	velocity.x = direction.x * SPEED

		
	$AnimatedSprite2D.flip_h = direction.x < 0
	move_and_slide()
	




