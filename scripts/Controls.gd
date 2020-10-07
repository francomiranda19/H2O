extends CanvasLayer


func _ready():
	$Back.connect("pressed", self, "on_Back_pressed")

func on_Back_pressed():
	$Click.play()
	LevelManager.change_scene("res://scenes/TitleScreen.tscn")
	
