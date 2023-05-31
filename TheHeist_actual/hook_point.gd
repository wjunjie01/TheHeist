extends Area2D

var cursor = load("res://art/crosshair007.png")
var old_cursor_shape = load("res://art/crosshair007.png")

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
#
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(old_cursor_shape, Input.CURSOR_ARROW,Vector2(16,16))

