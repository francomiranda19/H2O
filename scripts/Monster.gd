extends KinematicBody2D

var linear_vel = Vector2()
var speed = 400
var g = 1200
var can_double_jump = true
var crouching = false
var in_area = 0

onready var playback = $AnimationTree.get("parameters/playback")

func check_crouch():
	if in_area == 0:
		crouching = false
	
func on_body_entered(body: Node):
	if not body.is_in_group("player"):
		in_area += 1
	
func on_body_exited(body: Node):
	if not body.is_in_group("player"):
		in_area -= 1
		check_crouch()
	
func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")
	
func _physics_process(delta):
	linear_vel.y += g * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	var on_floor = is_on_floor()
	
	var target_vel = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		0)
	
	linear_vel.x = lerp(linear_vel.x, target_vel.x * speed, 0.5)
	
	var attacking = Input.is_action_pressed("attack")
	var jumping = Input.is_action_just_pressed("jump")
	
	if attacking: 
		linear_vel.x = 0
	if jumping and (on_floor or can_double_jump):
		if can_double_jump:
			can_double_jump = false
		linear_vel.y = -speed
		
	if on_floor:
		can_double_jump = true
		if linear_vel.length_squared() > 10:
			playback.travel("run")
		if linear_vel.length_squared() <= 10:
			playback.travel("idle")
		var crouch_pressed = Input.is_action_pressed("crouch")
		if crouching or crouch_pressed:
			crouching = true
			playback.travel("crouch")
		if crouching and not crouch_pressed:
			check_crouch()
	else:
		if linear_vel.y > 0:
			playback.travel("fall")
		else:
			playback.travel("jump")
	
	if attacking:
		playback.travel("attack")
		
	if target_vel.x < 0:
		$Sprite.flip_h = true
	if target_vel.x > 0:
		$Sprite.flip_h = false
