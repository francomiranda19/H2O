extends Node2D

onready var current_checkpoint = $Checkpoints.get_child(0) 

func _ready():
	for checkpoint in $Checkpoints.get_children():
		checkpoint.connect("player_entered", self, "on_player_entered")
		
func spawned(monster):
	for enemy in $Enemies.get_children():
		enemy._target = monster
		
func on_player_entered(checkpoint):
	current_checkpoint = checkpoint

func teleport_checkpoint(player):
	player.global_position = current_checkpoint.get_node("Spawn").global_position
	for ice in $IcePlatform.get_children():
		ice.enable(true)
