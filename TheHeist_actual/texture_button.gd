extends TextureButton

@export var text = 'Text Button'
@export var margin = 200

func _ready():
	setup_text()
	show_sword()
	
func _process(delta):
	if Engine.editor_hint:
		setup_text()
		show_sword()
	
func setup_text():
	$RichTextLabel.bbcode_text = "[center] %s [/center]" % [text]

func show_sword():
	for sword in [$LeftSword, $RightSword]:
		sword.visible = true
		sword.global_position.y = global_position.y + 40 / 3
		
	var center_x = global_position.x + (1920 / 2)
	$LeftSword.global_position.x = center_x - margin
	$RightSword.global_position.x = center_x + margin
