extends KinematicBody2D

var linear_vel = Vector2()
var speed = 400
var g = 1200

var can_double_jump = true
var crouching = false
var in_area = 0
var facing_right = true

export var num_lives = 2
onready var lives_label = $CanvasLayer2/Panel/MarginContainer/HBoxContainer/Label2

var health = 100 setget set_health

var Bullet = preload("res://scenes/MonsterBullet.tscn")
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
	lives_label.text = String(num_lives)
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")
	$Timer.connect("timeout",self, "on_timeout")
	
func on_timeout():
	modulate.a = 1
	
func travel(animation):
	playback.travel(animation)
	
func set_animation(animation):
	$AnimationTree.set("parameters/%s/blend_position" % animation, Vector2(health, 0))
	
func set_animations():
	set_animation("attack")
	set_animation("attack_start")
	set_animation("crouch")
	set_animation("crouch_start")
	set_animation("crouch_start 2")
	set_animation("fall")
	set_animation("idle")
	set_animation("jump")
	set_animation("jump_start")
	set_animation("run")
	
func _physics_process(delta):
	set_animations()
	
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
	var crouch_pressed = Input.is_action_pressed("crouch")
	
	if attacking_press and on_floor: 
		linear_vel.x = 0
	if jumping and (on_floor or can_double_jump) and in_area == 0:
		if can_double_jump:
			can_double_jump = false
		linear_vel.y = -speed
		
	if on_floor:
		can_double_jump = true
		if linear_vel.length_squared() > 10:
			travel("run")
		if linear_vel.length_squared() <= 10:
			travel("idle")
		if crouching or crouch_pressed:
			crouching = true
			if health > 20:
				linear_vel.x = 0
			travel("crouch")
		if crouching and not crouch_pressed:
			check_crouch()
	else:
		if linear_vel.y > 0:
			travel("fall")
		else:
			travel("jump")
			
	if in_area == 0:
		if attacking_press:
			travel("attack_start")
		if attacking_released:
			travel("attack")
	
	if health <= 0:
		travel("death")
		linear_vel = Vector2(0, 300)
			
	if facing_right and target_vel.x < 0 and health > 0:
		$Sprite.flip_h = true
		facing_right = false
	if not facing_right and target_vel.x > 0 and health > 0:
		$Sprite.flip_h = false
		facing_right = true
			
func fire():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	if health > 70:
		bullet.scale = 5 * Vector2.ONE
	elif 40 < health and health <= 70:
		bullet.scale = 3.5 * Vector2.ONE
	elif 20 < health and health <= 40:
		bullet.scale = 2 * Vector2.ONE
	else:
		bullet.scale = Vector2.ONE
		
	bullet.rotation = 0 if facing_right else PI
	var bullet_position = global_position
	bullet_position.x += ($Bullet.position.x if facing_right else -$Bullet.position.x) * scale.x
	bullet_position.y += $Bullet.position.y * scale.y
	bullet.global_position = bullet_position
	set_health(health - 9)

func take_damage(damage):
	if not $Timer.is_stopped():
		return
	self.health -= damage
	$Timer.start()
	modulate.a = 0.5
	
func heal(amount):
	if not $Timer.is_stopped():
		return
	if health < 100:
		self.health += amount
		$Timer.start()
		modulate.a = 0.5
		
func reduce_life():
	if num_lives <= 0:
		LevelManager.change_scene("res://scenes/Death.tscn")
		return
	self.health = 60 
	num_lives -= 1
	lives_label.text = String(num_lives)
	if get_parent().has_method("teleport_checkpoint"):
		get_parent().teleport_checkpoint(self)
