extends CharacterBody2D

const speed = 200
const GRAVITY = 800

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity.x = dir.x * speed
	
	if is_on_wall():
		print('hi')
		velocity.y = -400
		
	if is_on_floor():
		print("on floor")
		velocity.y = 0
	else:
		velocity.y = GRAVITY * delta
	move_and_slide()

func jump():
	print('jump')
	velocity.y = -400

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()
