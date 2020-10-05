extends StaticBody2D

var bodies = []

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")

func _physics_process(delta):
	for body in bodies:
		if body.has_method("heal"):
				body.heal(2)

func on_body_entered(body: Node):
	bodies.append(body)
	
func on_body_exited(body: Node):
	bodies.erase(body)
