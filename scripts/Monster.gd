extends KinematicBody2D

var linear_vel = Vector2()
var speed = 400
var g = 1200

var can_double_jump = true
var crouching = false
var in_area = 0
var facing_right = true

var health = 100 setget set_health

var Bullet = preload("res://scenes/Bullet.tscn")
onready var playback = $AnimationTree.get("parameters/playback")

func set_health(value):
	health = clamp(value, 0, 100)
	$CanvasLayer/HealthBar.value = value
	
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
	$Timer.connect("timeout",self,"on_timeout")
	
func on_timeout():
	modulate.a = 1
	
func _physics_process(delta):
	linear_vel.y += g * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	var on_floor = is_on_floor()
	
	var target_vel = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		0)
	
	linear_vel.x = lerp(linear_vel.x, target_vel.x * speed, 0.5)
	
	var attacking_press = Input.is_action_pressed("attack")
	var attacking_released = Input.is_action_just_released("attack")
	var jumping = Input.is_action_just_pressed("jump")
	
	if attacking_press and on_floor: 
		linear_vel.x = 0
	if jumping and (on_floor or can_double_jump) and in_area == 0:
		if can_double_jump:
			can_double_jump = false
		linear_vel.y = -speed
		
	if health <= 0:
		playback.travel("death 20")
		linear_vel = Vector2(0, 300)
	
	elif health > 0:
		if on_floor:
			can_double_jump = true
			if linear_vel.length_squared() > 10:
				playback.travel("run 20")
			if linear_vel.length_squared() <= 10:
				playback.travel("idle 20")
			var crouch_pressed = Input.is_action_pressed("crouch")
			if crouching or crouch_pressed:
				crouching = true
				playback.travel("crouch 20")
			if crouching and not crouch_pressed:
				check_crouch()
		else:
			if linear_vel.y > 0:
				playback.travel("fall 20")
			else:
				playback.travel("jump 20")
				
		if in_area == 0:
			if attacking_press:
				playback.travel("attack_start 20")
			if attacking_released:
				playback.travel("attack 20")
			
		if facing_right and target_vel.x < 0:
			$Sprite.scale.x = -$Sprite.scale.x
			$Bullet.position.x = -$Bullet.position.x
			facing_right = false
		if not facing_right and target_vel.x > 0:
			$Sprite.scale.x = -$Sprite.scale.x
			$Bullet.position.x = -$Bullet.position.x
			facing_right = true
			
func fire():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.rotation = 0 if facing_right else PI
	bullet.global_position = $Bullet.global_position
	set_health(health - 3)

func take_damage(damage):
	if not $Timer.is_stopped():
		return
	self.health -= damage
	$Timer.start()
	modulate.a = 0.5
