extends StaticBody2D

var closed = true
var bodies = []

func _physics_process(delta):
	if closed and Input.is_action_just_pressed("action"):
		var space_state = get_world_2d().direct_space_state
		var query = Physics2DShapeQueryParameters.new()
		query.set_shape($Area2D/CollisionShape2D.shape)
		query.transform = $Area2D/CollisionShape2D.get_global_transform()
		var results = space_state.intersect_shape(query)
		var is_player = false
		for result in results:
			if result.collider.is_in_group("player"):
				is_player = true
				break
		if is_player:
			print("hola")
			$AnimatedSprite.playing=true
			$Izq.set_deferred("disabled",false)
			$Der.set_deferred("disabled",false)
			$Cerrada.set_deferred("disabled",true)
			$Abierta.set_deferred("disabled",false)
			closed=false
