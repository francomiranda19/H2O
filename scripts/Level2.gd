extends Node2D

onready var current_checkpoint = $Node2D.get_child(0) 

func _ready():
	$Rain.play("rain")
	for checkpoint in $Node2D.get_children():
		checkpoint.connect("player_entered", self, "on_player_entered")
		
func on_player_entered(checkpoint):
	current_checkpoint = checkpoint

func teleport_checkpoint(player):
	player.global_position = current_checkpoint.get_node("Spawn").global_position
