extends CanvasLayer


func _ready():
	$Panel/VBoxContainer/Start.connect("pressed", self, "on_Start_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")
	
func on_Start_pressed():
	$Click.play()
	LevelManager.next()
	
func on_Exit_pressed():
	$Click.play()
	get_tree().quit()
