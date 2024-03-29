extends Node2D

var once = true
var can_hide = false

func _ready():
	Engine.time_scale = .2

	
func _process(_delta):
	if once and Input.is_action_just_pressed("hide") and can_hide:
		once = false
		Engine.time_scale = 1
		$PressR.hide()
		$HookCollider.queue_free()

func _on_hidden_area_hiding_area_entered():
	can_hide = true

func _on_hidden_area_hiding_area_exited():
	can_hide = false

func _on_player_game_over():
	Engine.time_scale = 1

