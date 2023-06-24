extends Area2D

var entered = false
var first_time = true
@onready var save_file = SaveFile.user_data

func _on_body_entered(body: PhysicsBody2D):
	if first_time: 
		entered = true

func _process(delta):
	if entered == true:
		save_file.level += 1
		SceneTransition.change_scene_clouds("res://level_" + str(save_file.level) + ".tscn")
		SaveFile.save_data()
		entered = false
		first_time = false
