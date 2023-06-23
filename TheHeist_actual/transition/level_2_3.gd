extends Area2D

var entered = false
var first_time = true

func _on_body_entered(body: PhysicsBody2D):
	if first_time: 
		entered = true

func _process(delta):
	if entered == true:
		SceneTransition.change_scene_clouds('res://level_3.tscn')
		entered = false
		first_time = false
