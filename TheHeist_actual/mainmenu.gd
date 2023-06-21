extends Node

@export var speed: int = 8
@export var rotation_speed: float = 0.3

var direction = Vector2(1,0)

@onready var parallax = $ParallaxBackground
@onready var button = $VBoxContainer/VBoxContainer/TextureButton
@onready var suzume = $Suzume

func _ready():
	pass

func _process(delta):
	parallax.scroll_offset += direction * speed * delta
	if self.visible:
		suzume.play()
	else:
		suzume.stop()

func _on_texture_button_pressed():
	print('New game pressed')
	$OKAY.play()
	var next_level = preload("res://level_1.tscn").instantiate()
	get_parent().get_parent().add_child(next_level)
	self.visible = false
#	SceneTransition.change_scene("res://level_1.tscn")

func _on_texture_button_2_pressed():
	print('Continue pressed')

func _on_texture_button_3_pressed():
	print('Exit pressed')
	get_tree().quit()
