extends CharacterBody2D

@onready var CheckLeft = $CheckLeft
@onready var CheckRight = $CheckRight

const SPEED = 90.0
var direction = Vector2.RIGHT #unit vector to the right

signal player_hit

func move():
	var found_wall = is_on_wall()
	#If colliding 
	var found_obstacle = (CheckLeft.is_colliding() or CheckRight.is_colliding())
	#Change direction
	if found_wall or found_obstacle:
		direction *= -1
	velocity.x = direction.x * SPEED
	$SpriteSheet.flip_h = direction.x > 0 #flip h if moving right

func _physics_process(_delta):
	move()
	move_and_slide()

func _on_area_2d_body_entered(body):
	$bite.play()
	body.gameover()
