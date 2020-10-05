extends Area2D

var health = 100 setget set_health
var death = false

func set_health(value):
	health = value
	$ProgressBar.value = value

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	$AnimationPlayer.play("shoot")
	
func on_animation_finished(anim_name: String):
	queue_free()

func take_damage(damage):
	var new_health = max(health - damage, 0)
	if health > 0:
		set_health(new_health) 
	if new_health == 0:
		death = true
		$AnimationPlayer.play("death")
