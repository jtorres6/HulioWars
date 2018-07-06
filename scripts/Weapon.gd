extends Node2D

var mouse_position = Vector2()

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
       mouse_position = event.position

func _process(delta):
	get_node("Sprite").look_at(mouse_position)
