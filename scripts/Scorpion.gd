extends KinematicBody2D

var linear_vel = Vector2()
var g = 1200
var speed = 300

var health = 40 setget set_health
var death = false
var player: Node2D = null
export var target: NodePath
onready var _target: Node2D = get_node(target)
var ScorpionBullet = preload("res://scenes/ScorpionBullet.tscn")
var facing_right = false
var radius_squared = 1200000
var distance = 2200000
var melee_distance = 50000

func set_health(value):
	health = value
	$ProgressBar.value = value

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	#$Area2D.connect("body_entered", self, "on_body_entered")
	#$Area2D.connect("body_exited", self, "on_body_exited")
	#SOLUCIONAR
	$Timer.connect("timeout", self, "on_timeout")
	$AnimationPlayer.play("shoot")
	
func on_animation_finished(anim_name: String):
	queue_free()

func fire():
	var scorpion_bullet = ScorpionBullet.instance()
	get_parent().add_child(scorpion_bullet)
	scorpion_bullet.global_position = $Bullet.global_position
	scorpion_bullet.rotation = (_target.global_position - global_position).angle()

func on_timeout():
	if _target and not death:
		fire()

func _physics_process(delta):
	linear_vel.y += g * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	linear_vel.x = 0
	
	if _target:
		if (_target.global_position - global_position).length_squared() < radius_squared:
			if $Timer.is_stopped():
				$Timer.start()
		else:
			if not $Timer.is_stopped():
				$Timer.stop()
		if (_target.global_position - global_position).length_squared() < distance and not death:
			linear_vel.x = lerp(linear_vel.x, -speed, 0.5)
		if (_target.global_position - global_position).length_squared() < melee_distance:
			linear_vel.x = 0
		if _target.global_position.x > global_position.x and not facing_right:
			scale.x *= -1
			speed *= -1
			facing_right = true
		if _target.global_position.x < global_position.x and facing_right:
			scale.x *= -1
			speed *= -1
			facing_right =  false

func take_damage(damage):
	var new_health = max(health - damage, 0)
	if health > 0:
		set_health(new_health) 
	if new_health <= 0:
		linear_vel.x = 0
		death = true
		$AnimationPlayer.play("death")
