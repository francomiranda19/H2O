extends Area2D

var health = 100 setget set_health
var death = false

func set_health(value):
	health = value
	$ProgressBar.value = value

func _ready():
	connect("area_entered", self, "on_area_entered")
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	$AnimationPlayer.play("shoot")
	
func on_animation_finished(anim_name: String):
	queue_free()
	
func on_area_entered(area: Area2D):
	if area.is_in_group("shoot") and not death:
		var new_health = max(health - 50, 0)
		if health > 0:
			set_health(new_health) 
		if new_health == 0:
			death = true
			$AnimationPlayer.play("death")
