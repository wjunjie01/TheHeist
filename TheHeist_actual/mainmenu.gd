extends Node

@export var speed: int = 8
@export var rotation_speed: float = 0.3

var direction = Vector2(1,0)

@onready var parallax = $ParallaxBackground

func _ready():
	$VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	$Suzume.play()

func _process(delta):
	parallax.scroll_offset += direction * speed * delta

func _on_texture_button_pressed():
	print('New game pressed')
	$OKAY.play()
	SceneTransition.change_scene("res://level_1.tscn")

func _on_texture_button_2_pressed():
	print('Continue pressed')

func _on_texture_button_3_pressed():
	print('Exit pressed')
