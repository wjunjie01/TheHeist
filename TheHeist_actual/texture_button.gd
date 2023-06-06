extends TextureButton

@export var text = 'Text Button'
@export var margin = 200

func _ready():
	setup_text()
	hide_sword()
	

	
func setup_text():
	$RichTextLabel.bbcode_text = "[center] %s [/center]" % [text]

func hide_sword():
	for sword in [$LeftSword, $RightSword]:
		sword.visible = false

func show_sword():
	for sword in [$LeftSword, $RightSword]:
		sword.visible = true
		sword.global_position.y = global_position.y + 180 / 3
		
	var center_x = global_position.x + (1920 / 2)
	$LeftSword.global_position.x = center_x - margin
	$RightSword.global_position.x = center_x + margin


func _on_focus_entered():
	show_sword()

func _on_focus_exited():
	hide_sword()

func _on_mouse_entered():
	grab_focus()
