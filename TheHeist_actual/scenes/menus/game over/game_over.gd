extends CanvasLayer

func _ready():
	var player = get_parent().get_node("Player")
	player.game_over.connect(_on_player_game_over)
	hide()


func _on_player_game_over():
	show()
	$"Mario death".play()


func _on_button_pressed():
	hide()
	get_tree().reload_current_scene()


func _on_button_2_pressed():
	hide()
	SceneTransition.change_scene("res://scenes/menus/main menu/main_menu.tscn")
