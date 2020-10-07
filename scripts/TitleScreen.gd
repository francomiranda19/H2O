extends CanvasLayer


func _ready():
	$Panel/VBoxContainer/Start.connect("pressed", self, "on_Start_pressed")
	$Panel/VBoxContainer/Como_jugar.connect("pressed", self, "on_Controls_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")
	
func on_Start_pressed():
	$Click.play()
	LevelManager.next()
	
func on_Controls_pressed():
	$Click.play()
	LevelManager.change_scene("res://scenes/Controls.tscn")

func on_Exit_pressed():
	$Click.play()
	get_tree().quit()
