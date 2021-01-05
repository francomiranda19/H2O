extends VideoPlayer

func _on_FLV_finished():
	LevelManager.next()
