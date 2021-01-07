extends RigidBody2D

func _ready():
	connect("body_entered", self, "on_body_entered")
	var new_scale = Vector2.ONE * 3
	$CollisionShape2D.scale = new_scale
	$AnimatedSprite.scale = new_scale
	
func on_body_entered(body: Node):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(13)
	queue_free()
	
func _physics_process(delta):
	if global_position.y > 20000:
		queue_free()
