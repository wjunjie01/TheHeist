extends CharacterBody2D

const SPEED = 200

var direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var bullet_scene = preload("res://scenes/interactables/bullet/bullet.tscn")

@onready var MuzzleLeft = $MuzzleLeft
@onready var MuzzleRight = $MuzzleRight
@onready var player = get_parent().get_node("Player")
var current_muzzle
var is_destroyed = false:
	set(value):
		is_destroyed = value
		if value:
			$Shoot_cooldown.stop()
			$Move_cooldown.stop()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Destroyed")
			$CollisionShape2D.position.y += 40

@export var x_min = 500
@export var x_max = 1500
@export var y_min = 200
@export var y_max = 300

func _ready():
	current_muzzle = MuzzleLeft
	$AnimationPlayer.play("Walk")
	
func _physics_process(delta):
	move_and_slide()
	if is_destroyed:
		move_and_slide()
		if not is_on_floor():
			position.y += 15
		return
	else:
		position.x = clamp(position.x, x_min, x_max)
		position.y = clamp(position.y, y_min, y_max)
		position += direction * SPEED * delta
		$DroneSpritesheet.flip_h = direction.x < 0
	
		var left_dist = abs(MuzzleLeft.global_position - player.global_position)
		var right_dist = abs(MuzzleRight.global_position - player.global_position)
		
		if left_dist < right_dist:
			current_muzzle = MuzzleLeft
		else:
			current_muzzle = MuzzleRight
		
		
func _on_move_cooldown_timeout():
	var randint = rng.randi_range(0, 3)
	match randint:
		0: direction = Vector2.UP
		1: direction = Vector2.DOWN
		2: direction = Vector2.LEFT
		3: direction = Vector2.RIGHT

func _on_shoot_cooldown_timeout():
	if player.current_state != 6:
		var bullet = bullet_scene.instantiate()
		var player_pos = player.global_position
		bullet.position = current_muzzle.global_position
		bullet.direction = (player_pos - current_muzzle.global_position).normalized()
		get_parent().add_child(bullet)
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Destroyed":
		queue_free()
