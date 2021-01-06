extends Position2D

var Rocket = preload("res://scenes/Rocket.tscn")

func _ready():
	$Timer.connect("timeout", self, "on_timeout")

func on_timeout():
	var rocket = Rocket.instance()
	add_child(rocket)
	rocket.global_position = Vector2(global_position.x+rand_range(-100,100),global_position.y)
