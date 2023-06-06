extends CanvasLayer

func _ready():
	hide()


func _on_player_game_over():
	show()


func _on_button_pressed():
	hide()
	get_tree().reload_current_scene()
