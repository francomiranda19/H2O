extends StaticBody2D

func _ready():
	$Area2D.connect("body_entered",self,"on_body_entered")
	$Collapse.connect("animation_finished",self,"on_animation_finished")

func on_body_entered(body: Node):
	if body.is_in_group("player"):
		$Collapse.play("default")

func on_animation_finished():
	queue_free()
		
		
