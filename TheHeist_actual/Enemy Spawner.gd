extends Marker2D


var melee_enemy_scene = preload("res://melee_enemy.tscn")
var ranged_enemy_scene = preload("res://ranged enemy.tscn")

func _ready():
	if get_parent().has_node("drones"):
		var drones = get_parent().get_node("drones").get_children()
		for drone in drones:
			drone.player_detected.connect(_spawn_enemies)

func _spawn_enemies():
	var ranged_enemy = ranged_enemy_scene.instantiate()
	get_parent().call_deferred("add_child", ranged_enemy)
	ranged_enemy.position = position
	
