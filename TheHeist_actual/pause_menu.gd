extends Control

@export var Game_Manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_game_manager_toggle_game_paused(is_paused: bool):
	if is_paused:
		show()
	else:
		hide()

func _on_resume_button_pressed():
	Game_Manager.game_paused = false
	

func _on_main_menu_button_pressed():
	hide()
	Game_Manager.game_paused = false
	get_parent().get_node("MainMenu").visible = true
	var children = get_parent().get_parent().get_children()
	for node in children:
		if node.name != ("CanvasLayer"):
			node.free()
	

func _on_exit_button_pressed():
	get_tree().quit()
