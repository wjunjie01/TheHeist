extends Area2D

@onready var save_file = SaveFile.user_data

func _on_body_entered(body):
	set_collision_mask_value(2, false)
	body.visible = false
	save_file.level += 1
	print(save_file.level)
	SceneTransition.change_scene_clouds("res://scenes/levels/level_"  + str(save_file.level) + ".tscn")
	SaveFile.save_data()
	
