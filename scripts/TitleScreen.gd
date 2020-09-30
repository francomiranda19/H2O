extends CanvasLayer


func _ready():
	$Panel/VBoxContainer/Start.connect("pressed",self,"on_Start_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed",self,"on_Exit_pressed")
	
func on_Start_pressed():
	LevelManager.next()
	
func on_Exit_pressed():
	get_tree().quit()


