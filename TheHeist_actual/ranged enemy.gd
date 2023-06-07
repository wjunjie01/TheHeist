extends CharacterBody2D

@onready var LedgeCheckRight = $LedgeCheckRight
@onready var LedgeCheckLeft = $LedgeCheckLeft
@onready var PlayerDetector = $PlayerDetector
@onready var MuzzleRight = $MuzzleRight
@onready var MuzzleLeft = $MuzzleLeft
@onready var Animation_tree = $AnimationTree

const SPEED = 100.0
var direction = Vector2.RIGHT
var curr_muzzle
var can_shoot = true
var bullet_scene = preload("res://bullet.tscn")
var is_dead = false



func _ready():
	Animation_tree.active = true
	curr_muzzle = MuzzleRight
	
func _physics_process(_delta):
	if is_dead:
		dead()
	
	elif PlayerDetector.is_colliding() and can_shoot:
		Animation_tree["parameters/conditions/walk"] = false
		Animation_tree["parameters/conditions/shoot"] = true
		
	elif Animation_tree["parameters/conditions/walk"] == true:
		move()
		
	move_and_slide()
	
func start_of_shoot():
	velocity = Vector2.ZERO
	
	
func end_of_shoot():
	shoot()
	velocity.x = direction.x * SPEED
	Animation_tree["parameters/conditions/walk"] = true
	Animation_tree["parameters/conditions/shoot"] = false
	
func dead():
	velocity = Vector2.ZERO
	Animation_tree["parameters/conditions/walk"] = false
	Animation_tree["parameters/conditions/death"] = true

func move():
#	Animation_tree["parameters/conditions/walk"] = true
	var found_wall = is_on_wall()
	# If not colliding with ground in front, ledge is found.
	# If colliding, ledge not found
	var found_ledge = not (LedgeCheckRight.is_colliding() and LedgeCheckLeft.is_colliding())

	# Change direction if reach a ledge or wall
	if found_wall or found_ledge:
		direction *= -1
		PlayerDetector.scale.x *= -1
		if curr_muzzle == MuzzleRight:
			curr_muzzle = MuzzleLeft
		else:
			curr_muzzle = MuzzleRight
	
	velocity.x = direction.x * SPEED
	$SpriteSheet.flip_h = direction.x < 0
	

func shoot():
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	$Laser.play()
	bullet.direction = direction
	if direction.x == -1:
		bullet.get_node("BulletArt").flip_h = true
	else:
		bullet.get_node("BulletArt").flip_h = false
	bullet.position = curr_muzzle.position
	can_shoot = false
	

func _on_timer_timeout():
	can_shoot = true

