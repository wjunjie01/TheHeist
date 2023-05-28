extends Node2D

@onready var links = $Links
var direction = Vector2.ZERO
var tip = Vector2.ZERO

const SPEED = 20

var flying = false
var hooked = false

func shoot(dir:Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip = self.global_position #reflects the current position of the node
	
func release() -> void:
	flying = false
	hooked = false

#runs every frame to update the appearance of the chain
func _process(_delta):
	self.visible = flying or hooked #Make this entire node visible if it's flying or hooked
	if not self.visible:
		return
	var tip_loc = to_local(tip) #Coordinate is with reference to the node
	links.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	#comparing between 2 points angle, and changing it to face that direction
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	links.position = tip_loc
	links.region_rect.size.y = 2 * tip_loc.length() #extend the chain,frame by frame to match the length of tiploc
	
#runs every frame
func _physics_process(_delta):
	$Tip.global_position = tip #tip is already shifted, change the image position
	if flying:
		if $Tip.move_and_collide(direction * SPEED): #hit an obstacle
			hooked = true
			flying = false
	tip = $Tip.global_position #updates the tip to its next position (for collision)
