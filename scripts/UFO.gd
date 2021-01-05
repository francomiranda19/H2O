extends KinematicBody2D

var health = 300 setget set_health
var death = false
var player: Node2D = null
export var target: NodePath
onready var _target: Node2D = get_node(target)
var UFOBullet = preload("res://scenes/UFOBullet.tscn")
#var facing_right = false
var radius_squared = 5000000
#var distance = 2200000
#var melee_distance = 50000

func set_health(value):
	health = value
	$ProgressBar.value = value

func _ready():
	#$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	$Timer.connect("timeout", self, "on_timeout")
	#$AnimationPlayer.play("shoot")
	
func on_animation_finished(anim_name: String):
	queue_free()

func fire():
	var ufo_bullet = UFOBullet.instance()
	get_parent().add_child(ufo_bullet)
	ufo_bullet.global_position = $Bullet.global_position
	ufo_bullet.rotation = (_target.global_position - global_position).angle()

func on_timeout():
	if _target and not death:
		fire()

func _physics_process(delta):
	if _target:
		if (_target.global_position - global_position).length_squared() < radius_squared:
			if $Timer.is_stopped():
				$Timer.start()
		else:
			if not $Timer.is_stopped():
				$Timer.stop()

func take_damage(damage):
	var new_health = max(health - damage, 0)
	if health > 0:
		set_health(new_health) 
	if new_health <= 0:
		#linear_vel.x = 0
		death = true
		#$AnimationPlayer.play("death")
