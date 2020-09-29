extends Area2D

var speed = 700

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")

func _physics_process(delta):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta
