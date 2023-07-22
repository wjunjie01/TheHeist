extends CharacterBody2D

const SPEED = 200

var direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var bullet_scene = preload("res://bullet.tscn")

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


func _ready():
	current_muzzle = MuzzleLeft
	$AnimationPlayer.play("Walk")
	
func _physics_process(delta):
	if player.current_state == 5:
		$Shoot_cooldown.stop()
		
	move_and_slide()
	if is_destroyed:
		move_and_slide()
		if not is_on_floor():
			position.y += 15
		return
	else:
		position.x = clamp(position.x, 500, 1500)
		position.y = clamp(position.y, 200, 300)
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
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		var player_pos = player.global_position
		bullet.position = current_muzzle.global_position
		var bullet_dir = (player_pos - current_muzzle.global_position).normalized()
		bullet.velocity = bullet_dir
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Destroyed":
		queue_free()
