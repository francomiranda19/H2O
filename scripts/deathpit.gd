extends Node2D


func _ready():
	$Area2D.connect("body_entered",self,"on_body_entered")

func on_body_entered(body: Node):
	if body.has_method("reduce_life"):
		body.reduce_life()
