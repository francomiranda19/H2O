extends RigidBody2D

var random = rand_range(0.1, 0.3)

func _ready():
	connect("body_entered", self, "on_body_entered")
	var new_scale = Vector2.ONE * random
	$CollisionShape2D.scale = new_scale
	$gota.scale = new_scale
	
func on_body_entered(body: Node):
	if body.has_method("heal"):
		body.heal(30 * random)
	queue_free()
	
func _physics_process(delta):
	if global_position.y > 10000:
		queue_free()
