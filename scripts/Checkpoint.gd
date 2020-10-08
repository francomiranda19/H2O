extends Area2D

signal player_entered

func _ready():
	connect("body_entered", self, "on_body_entered")
		
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		emit_signal("player_entered", self)
