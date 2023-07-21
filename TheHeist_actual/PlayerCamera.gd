extends Camera2D

var RandomStrength = 30.0
var ShakeFade = 5.0

var rng = RandomNumberGenerator.new()

var ShakeStrength = 0.0

var TargetZoom = Vector2(1.6, 1.6)

func _ready():
	var scene_name = get_tree().get_current_scene().get_name()
	if scene_name == "level_8":
		zoom = Vector2(1, 1)
		set_process(false)
		await get_tree().create_timer(1.5).timeout
		set_process(true)
	
func apply_shake():
	ShakeStrength = RandomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom != Vector2(1.6, 1.6):
		var diff = TargetZoom - zoom
		if diff < Vector2(0.1, 0.1):
			zoom = TargetZoom
		else: 
			zoom += Vector2(0.02, 0.02)
		

	if ShakeStrength > 0:
		ShakeStrength = lerpf(ShakeStrength, 0, ShakeFade * delta)
		
		offset = randomOffset()
		
func randomOffset():
	return Vector2(rng.randf_range(-ShakeStrength, ShakeStrength), rng.randf_range(-ShakeStrength, ShakeStrength))
		
		
