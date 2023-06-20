extends CanvasLayer

func change_scene(new_scene: String): #money heist
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(new_scene)
	$AnimationPlayer.play_backwards("dissolve")

func change_scene_clouds(new_scene: String): #cloud
	$AnimationPlayer.play('clouds in')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(new_scene)
	$AnimationPlayer.play("clouds_out")

