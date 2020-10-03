tool 
extends StaticBody2D

export var time = 5 setget set_time
func set_time(value):
	time = value
	$Timer.wait_time = value
	print(value)
export var offset = 0.5

var bodies = []


func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")
	if offset>0:	
		$Timer.wait_time = offset
		$Timer.one_shot = true
		$Timer.start()
		yield($Timer,"timeout")
	$Timer.wait_time = time
	$Timer.one_shot = false
	$Timer.start()
	$Timer.connect("timeout",self,"on_timeout")
	
func on_timeout():
	$Fire.visible = !$Fire.visible
	
func _physics_process(delta):
	if $Fire.visible:
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(5)
	

func on_body_entered(body: Node):
	bodies.append(body)
	
func on_body_exited(body: Node):
	bodies.erase(body)
	

	
	
