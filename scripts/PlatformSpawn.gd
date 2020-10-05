tool
extends Position2D

var Platform = preload("res://scenes/Platform.tscn")

export var amount = 0 setget set_amount
export var separation = 100 setget set_separation 
export var time = 5 setget set_time
export var offset = 0.5 setget set_offset
var is_ready = false

func _ready():
  is_ready = true

func set_time(value):
	time = value
	for i in get_child_count():
		get_child(i).time = time
	update()
	
func set_offset(value):
	offset = value
	for i in get_child_count():
		get_child(i).offset = offset*i
	update()

func set_amount(value):
	if value < 0:
		return
	amount = value
	var child_count = get_child_count()
	if amount > child_count:
		for i in range(amount-child_count):
			var platform = Platform.instance()
			platform.time = time
			platform.offset = offset*(child_count+i)
			add_child(platform)
			platform.position.x = separation*(child_count+i)
	if amount < child_count:
		for i in range(child_count-amount):
			remove_child(get_child(child_count-1-i))
	update()
	
func set_separation(value):
	separation = value
	for i in get_child_count():
		get_child(i).position.x = separation*i
	
func update():
	if is_ready:
		for i in get_child_count():
			get_child(i).start()
