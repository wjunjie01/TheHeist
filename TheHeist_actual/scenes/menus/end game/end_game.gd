extends Node2D

func _ready():
	$Avengers.play()


func _on_button_pressed():
	SceneTransition.change_scene("res://scenes/menus/main menu/main_menu.tscn")
