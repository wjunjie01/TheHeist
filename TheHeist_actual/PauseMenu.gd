extends Control

var is_paused = false : set = set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed('pause'):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed():
	self.is_paused = false

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	self.is_paused = !is_paused
	SceneTransition.change_scene('res://mainmenu.tscn')
