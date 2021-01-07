extends Area2D

var active = true
export var direction: Vector2 = Vector2(-800,0)

func _ready():
	$Timer.connect("timeout", self, "on_timeout")
	
func on_timeout():
	active = not active
	$Particles2D.set_deferred("emitting", active)
	$Particles2D2.set_deferred("emitting", active)
	
	
func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 2
	query.set_shape($CollisionShape2D.shape)
	query.transform = $CollisionShape2D.get_global_transform()
	var results = space_state.intersect_shape(query)
	var player = null
	for result in results:
		if result.collider.is_in_group("player"):
			player = result.collider
			player.linear_vel+= direction*delta
			return
