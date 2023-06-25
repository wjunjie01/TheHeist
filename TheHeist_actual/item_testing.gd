extends Node2D
@onready var player = $Player
@onready var melee_enemy = $"Melee Enemy"
@onready var ranged_enemy = $"Ranged Enemy"

func _ready():
	melee_enemy.get_node("PlayerDetector").monitoring = false
	ranged_enemy.get_node("PlayerDetector").enabled = false
