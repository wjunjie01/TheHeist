extends CanvasLayer

func _ready():
	var player = get_parent().get_node("Player")
	player.game_over.connect(_on_player_game_over)
	hide()


func _on_player_game_over():
	show()


func _on_button_pressed():
	get_tree().reload_current_scene()


func _on_button_2_pressed():
	hide()
	SceneTransition.change_scene('res://mainmenu.tscn')
