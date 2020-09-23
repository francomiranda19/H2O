extends KinematicBody2D

var linear_vel= Vector2()
var speed= 400
var gravity= 800
onready var playback= $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	linear_vel.y+=gravity*delta
	linear_vel=move_and_slide(linear_vel,Vector2.UP)
	
	var on_floor= is_on_floor()
	
	var target_vel= Vector2(Input.get_action_strength("derecha")-Input.get_action_strength("izquierda"),0)
	linear_vel.x=lerp(linear_vel.x,target_vel.x*speed,0.5)
	if on_floor:
		if linear_vel.length_squared()>10:
			playback.travel("Run")
		if linear_vel.length_squared()<=10:
			playback.travel("Idle")
		if Input.is_action_just_pressed("salto"):
			linear_vel.y-=speed
			playback.travel("Jump")
	if target_vel.x<0:
		$Sprite.flip_h=true
	if target_vel.x>0:
		$Sprite.flip_h=false
