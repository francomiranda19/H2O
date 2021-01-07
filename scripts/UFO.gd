extends KinematicBody2D

var in_base = false

var health = 500 setget set_health
var death = false
var player: Node2D = null
export var target: NodePath
onready var _target: Node2D = get_node(target)
var UFOBullet = preload("res://scenes/UFOBullet.tscn")

func set_health(value):
	health = value
	$ProgressBar.value = value

func _ready():
	$NotInBaseTimer.connect("timeout", self, "on_timeout_not_in_base")
	$ChangeTimer.connect("timeout", self, "on_timeout_change");
	$WaitTimer.connect("timeout", self, "on_timeout_wait")
	$NotInBaseTimer.start()
	$ChangeTimer.start();

func fire():
	var ufo_bullet = UFOBullet.instance()
	get_parent().add_child(ufo_bullet)
	ufo_bullet.global_position = $Bullet.global_position
	ufo_bullet.rotation = (_target.global_position - global_position).angle()

func on_timeout_not_in_base():
	if _target and not (death or in_base):
		fire()
		
func on_timeout_change():
	in_base = not in_base
	if not in_base:
		$WaitTimer.start()

func on_timeout_wait():
	$WaitTimer.stop()
	$NotInBaseTimer.start()

func _physics_process(delta):
	if _target:
		if in_base and not $NotInBaseTimer.is_stopped():
			$NotInBaseTimer.stop()

func take_damage(damage):
	var new_health = max(health - damage, 0)
	if health > 0:
		set_health(new_health) 
	if new_health <= 0:
		death = true
		LevelManager.next()
