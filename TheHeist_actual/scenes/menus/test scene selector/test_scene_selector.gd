extends Node2D

func _on_attack_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/backstabbing_testing.tscn")


func _on_enemy_attack_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/enemy_testing.tscn")


func _on_item_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/item_testing.tscn")


func _on_drones_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/drones_testing.tscn")


func _on_environment_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/environment_testing.tscn")

func _on_boss_testing_pressed():
	get_tree().change_scene_to_file("res://scenes/test scenes/boss_testing.tscn")
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main menu/main_menu.tscn")


