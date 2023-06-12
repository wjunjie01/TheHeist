extends CharacterBody2D

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft
@onready var Animation_tree = $AnimationTree
@onready var PlayerDetector = $PlayerDetector
@onready var AttackDetector = $AttackDetector

signal player_hit

const SPEED = 80.0
var direction = Vector2.RIGHT
var is_dead = false

func _ready():
	Animation_tree.active = true
	
func dead():
	velocity = Vector2.ZERO
	Animation_tree["parameters/conditions/walk"] = false
	Animation_tree["parameters/conditions/death"] = true

func move():
	var found_wall = is_on_wall()
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())
	# Change direction if reach a ledge or wall
	if found_wall or found_ledge:
		direction *= -1
		PlayerDetector.scale.x *= -1
		AttackDetector.scale.x *= -1
	velocity.x = direction.x * SPEED
	$SpriteSheetMelee.flip_h = direction.x < 0

func start_of_hit():
	AttackDetector.monitoring = true
	
	
func end_of_hit():
	AttackDetector.monitoring = false
	Animation_tree["parameters/conditions/attack"] = false
	Animation_tree["parameters/conditions/walk"] = true

func _physics_process(_delta):
	if is_dead:
		dead()
	
	elif Animation_tree["parameters/conditions/walk"] == true:
		move()
		
	move_and_slide()

func _on_PlayerDetector_body_entered(body):
	velocity = Vector2.ZERO
	Animation_tree["parameters/conditions/walk"] = false
	Animation_tree["parameters/conditions/attack"] = true

func _on_AttackDetector_body_entered(body):
	emit_signal('player_hit')
