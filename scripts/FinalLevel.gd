extends Node2D

onready var current_checkpoint = $Node2D.get_child(0)

func _ready():
	for checkpoint in $Node2D.get_children():
		checkpoint.connect("player_entered", self, "on_player_entered")
	randomize()
	$Tween.connect("tween_all_completed", self, "on_tween_all_completed")
	move()
	$Tween.start()
	
func on_player_entered(checkpoint):
	current_checkpoint = checkpoint

func teleport_checkpoint(player):
	player.global_position = current_checkpoint.get_node("Spawn").global_position
	
func on_tween_all_completed():
	move()
	$Tween.start()
	
func move():
	if not $UFO.in_base:
		$Tween.interpolate_property($UFO, "position:x", $UFO.position.x, rand_range(300, 1500), 2.1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($UFO, "position:y", $UFO.position.y, rand_range(100, 200), 2.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property($UFO, "position:x", $UFO.position.x, 1650, 2.1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($UFO, "position:y", $UFO.position.y, 900, 2.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	
