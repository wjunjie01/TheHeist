extends Node2D

@onready var player = $Player
@onready var melee_enemy = $"MeleeEnemy"
@onready var ranged_enemy = $"RangedEnemy"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	melee_enemy.get_node("PlayerDetector").monitoring = false
	ranged_enemy.get_node("PlayerDetector").enabled = false
	

