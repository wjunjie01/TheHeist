class_name HookPoint_Class
extends Area2D

enum HOOKTYPE {
	STICKY,
	UNSTICKY
}

@export var hookType : HOOKTYPE = HOOKTYPE.UNSTICKY
@export var heightOffset : float = 0

@export var cursor : Resource = load("res://art/crosshair007.png")
@export var old_cursor_shape : Resource = null
var currCursor : Resource = null

var player : Player_Class
var mouseInside : bool = false

func _on_mouse_entered():
	mouseInside = true

func _on_mouse_exited():
	mouseInside = false
	SetCursor(old_cursor_shape)

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if mouseInside:
		UpdateMouseCursor()
	pass

func UpdateMouseCursor():
	var canHook : bool = player.ray_free_obstacles()
	
	if canHook && currCursor != cursor:
		SetCursor(cursor)
	elif !canHook && currCursor != old_cursor_shape:
		SetCursor(old_cursor_shape)
	pass

func SetCursor(cursorResource : Resource):
	if cursorResource:
		Input.set_custom_mouse_cursor(cursorResource, Input.CURSOR_ARROW,Vector2(16,16))
		currCursor = cursorResource
	else:
		Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
		currCursor = null

func GetTargetedPosition() -> Vector2:
	var pos : Vector2 = global_position
	pos.y -= heightOffset
	
	return pos
