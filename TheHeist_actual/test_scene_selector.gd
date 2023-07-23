extends Node2D

func _on_attack_testing_pressed():
	get_tree().change_scene_to_file("res://backstabbing_testing.tscn")


func _on_enemy_attack_testing_pressed():
	get_tree().change_scene_to_file("res://enemy_testing.tscn")


func _on_item_testing_pressed():
	get_tree().change_scene_to_file("res://item_testing.tscn")


func _on_drones_testing_pressed():
	get_tree().change_scene_to_file("res://drones_testing.tscn")


func _on_environment_testing_pressed():
	get_tree().change_scene_to_file("res://environment_testing.tscn")

func _on_boss_testing_pressed():
	get_tree().change_scene_to_file("res://boss_testing.tscn")
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")


