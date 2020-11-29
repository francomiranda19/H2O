extends Area2D

var bodies = []

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func _physics_process(delta):
	for body in bodies:
		if body.has_method("heal"):
				body.heal(1)

func on_body_entered(body: Node):
	bodies.append(body)
	
func on_body_exited(body: Node):
	bodies.erase(body)
