extends RigidBody2D

func _ready():
	connect("body_entered", self, "on_body_entered")
	var new_scale = Vector2.ONE*rand_range(0.25,0.8)
	$CollisionShape2D.scale = new_scale
	$AnimatedSprite.scale = new_scale
	
func on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(12)
	queue_free()
	
func _physics_process(delta):
	if global_position.y>10000:
		queue_free()
