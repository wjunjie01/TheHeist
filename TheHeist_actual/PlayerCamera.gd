extends Camera2D

var RandomStrength = 30.0
var ShakeFade = 5.0

var rng = RandomNumberGenerator.new()

var ShakeStrength = 0.0

func apply_shake():
	ShakeStrength = RandomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ShakeStrength > 0:
		ShakeStrength = lerpf(ShakeStrength, 0, ShakeFade * delta)
		
		offset = randomOffset()
		
func randomOffset():
	return Vector2(rng.randf_range(-ShakeStrength, ShakeStrength), rng.randf_range(-ShakeStrength, ShakeStrength))
		
		
