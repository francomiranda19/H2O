extends Area2D

var active = true
export var direction: Vector2 = Vector2(-50,0)

func _ready():
	$Timer.connect("timeout", self, "on_timeout")
	
func on_timeout():
	active = not active
	#if active:
		#$Particles.play()
	#else:
		#$Particles.stop()
	
func _physics_process(delta):
	if active:
		var space_state = get_world_2d().direct_space_state
		var query = Physics2DShapeQueryParameters.new()
		query.set_shape($CollisionShape2D.shape)
		query.transform = $CollisionShape2D.get_global_transform()
		var results = space_state.intersect_shape(query)
		var player = null
		for result in results:
			if result.collider.is_in_group("player"):
				player = result.collider
				player.linear_vel+= direction*delta
				return
