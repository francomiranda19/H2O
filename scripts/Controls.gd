extends CanvasLayer


func _ready():
	$Back.connect("pressed",self,"on_Back_pressed")

func on_Back_pressed():
	$Click.play()
	get_tree().change_scene("res://scene/TitleScreen.tscn")
	
