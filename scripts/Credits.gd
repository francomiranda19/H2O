extends VideoPlayer

func _on_Credits_finished():
	LevelManager.change_scene("res://scenes/TitleScreen.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		LevelManager.change_scene("res://scenes/TitleScreen.tscn")
