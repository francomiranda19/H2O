extends StaticBody2D

var closed = true
var bodies = []

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body: Node):
	var action = Input.is_action_just_pressed("action")
	if closed and action:
		print("hola")
		$AnimatedSprite.playing = true
		$Izq.set_deferred("disabled", false)
		$Der.set_deferred("disabled", false)
		$Cerrada.set_deferred("disabled", true)
		$Abierta.set_deferred("disabled", false)
		closed = false
