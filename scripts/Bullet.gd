extends Area2D

var speed = 700

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta

func on_body_entered(body: Node):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(10)
	if not body.is_in_group("player"):
		queue_free()
