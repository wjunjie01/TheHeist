extends Marker2D

var cart_scene = preload("res://scenes/interactables/cart/cart.tscn")

func _ready():
	spawn_cart()

func spawn_cart():
	var cart = cart_scene.instantiate()
	get_parent().call_deferred("add_child", cart)
	cart.position = position

func _on_timer_timeout():
	spawn_cart()
