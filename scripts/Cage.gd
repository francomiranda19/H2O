extends Node2D

var hitpoints = 5
var animation_time = 0.5
var acc_time = 0
var Monster = preload("res://scenes/Monster.tscn")

func _ready():
	$AnimationPlayer.play("Start")
	set_process(false) 
	
func _process(delta):
	$Sprite.position = Vector2(randf(), randf()) * 10
	acc_time += delta
	if acc_time > animation_time:
		$Sprite.position = Vector2()
		set_process(false)
		
	
func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		hitpoints -= 1
		if hitpoints == 0:
			$AnimationPlayer.play("Broken")
			var monster = Monster.instance()
			get_parent().add_child(monster)
			get_parent().spawned(monster)
			monster.global_position = global_position
			$Camera2D.current = false
			set_physics_process(false)
		else:
			$AnimationPlayer.play("Hit")
			acc_time = 0
			set_process(true)
