extends Area2D

var shuriken_scene = preload("res://shuriken.tscn")
@onready var spawn_pos = $Marker2D
@onready var spawn_cooldown = $Timer

func _on_area_exited(area):
	spawn_shuriken()

func spawn_shuriken():
	spawn_cooldown.start()

func _on_timer_timeout():
	var shuriken = shuriken_scene.instantiate()
	get_parent().add_child(shuriken)
	shuriken.global_position = spawn_pos.global_position
