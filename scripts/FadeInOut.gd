extends ColorRect

signal faded
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	
func on_animation_finished(anim_name: String):
	emit_signal("faded")
	
func fade_in():
	$AnimationPlayer.play("FadeIn")
	
func fade_out():
	$AnimationPlayer.play("FadeOut")
