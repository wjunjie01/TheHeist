extends Node

@export var speed: int = 8
@export var rotation_speed: float = 0.3

var direction = Vector2(1,0)

@onready var save_file = SaveFile.user_data
@onready var parallax = $ParallaxBackground

func _ready():
	$VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	$Suzume.play()
	$no_data.hide()
	if save_file.level != 0:
		$current_level.text = 'Current level: ' + str(save_file.level)
		$current_level.show()

func _process(delta):
	parallax.scroll_offset += direction * speed * delta

func _on_texture_button_pressed():
	print('New game pressed')
	$OKAY.play()
	save_file.level = 1
	SceneTransition.change_scene("res://level_" + str(save_file.level) + ".tscn")
	SaveFile.save_data()

func _on_texture_button_2_pressed():
	print('Continue pressed')
	if save_file.level == 0:
			$no_data.show()
	else:
		SceneTransition.change_scene("res://level_" + str(save_file.level) + ".tscn")

func _on_texture_button_3_pressed():
	print('Exit pressed')
	get_tree().quit()


func _on_button_pressed():
	SceneTransition.change_scene("res://playground.tscn")


func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	pass # Replace with function body.
