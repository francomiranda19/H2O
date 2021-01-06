extends VideoPlayer

func _on_CutsceneFinal_finished():
	LevelManager.next()
