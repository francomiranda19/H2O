extends Position2D

var Drop = preload("res://scenes/Drop.tscn")

func _ready():
	$Timer.connect("timeout", self, "on_timeout")

func on_timeout():
	var drop = Drop.instance()
	add_child(drop)
	drop.global_position = Vector2(global_position.x + rand_range(-200, 200), global_position.y)
