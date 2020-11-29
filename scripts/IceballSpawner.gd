extends Position2D

var Iceball = preload("res://scenes/Iceball.tscn")

func _ready():
	$Timer.connect("timeout", self, "on_timeout")

func on_timeout():
	var iceball = Iceball.instance()
	add_child(iceball)
	iceball.global_position = Vector2(global_position.x+rand_range(-300,300),global_position.y)
