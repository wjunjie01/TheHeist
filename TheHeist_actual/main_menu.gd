extends Node2D

@export var speed: int = 8
@export var rotation_speed: float = 0.3

var direction = Vector2(1,0)

@onready var parallax = $ParallaxBackground

func _process(delta):
	parallax.scroll_offset += direction * speed * delta


