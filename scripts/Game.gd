extends Node2D

var Levels = [preload("res://scenes/Intro.tscn"),
	preload("res://scenes/TitleScreen.tscn"),
	preload("res://scenes/Cutscene1.tscn"),
	preload("res://scenes/Level1.tscn"), 
	preload("res://scenes/Cutscene2.tscn"),
	preload("res://scenes/Level2.tscn"),
	preload("res://scenes/Cutscene3.tscn"),
	preload("res://scenes/Level3.tscn"),
	preload("res://scenes/Cutscene4.tscn"),
	preload("res://scenes/Level4.tscn"),
	preload("res://scenes/Level5.tscn"),
	preload("res://scenes/FinalLevel.tscn")]

var current_level = 0
var current_world: Node = null
var loading = false

func change_scene(scene):
	var s = load(scene).instance()
	$World.remove_child(current_world)
	current_world.queue_free()
	current_world = s
	$World.add_child(current_world)
 
func next():
	if current_level + 1 >= Levels.size():
		return
	loading = true
	$CanvasLayer/FadeInOut.fade_in()

func _ready():
	$CanvasLayer/FadeInOut.connect("faded", self, "on_faded")
	current_world = Levels[0].instance()
	$World.add_child(current_world)
	
func on_faded():
	if loading:
		$World.remove_child(current_world)
		current_world.queue_free()
		current_level += 1
		current_world = Levels[current_level].instance()
		$World.add_child(current_world)
		loading = false
		$CanvasLayer/FadeInOut.fade_out()
		
func reset():
	current_level = 0
	loading = true
	$CanvasLayer/FadeInOut.fade_in()
