extends StaticBody2D

func _ready():
	$Area2D.connect("body_entered",self,"on_body_entered")
	$Collapse.connect("animation_finished",self,"on_animation_finished")

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		$Collapse.play("default")

func on_animation_finished():
	enable(false)
	
func enable(value):
	$Block.set_deferred("disabled", not value) 
	$Area2D/CollisionShape2D.set_deferred("disabled", not value) 
	if value:
		show()
		$Collapse.stop()
		$Collapse.frame = 0
	else:
		hide() 
		
		
