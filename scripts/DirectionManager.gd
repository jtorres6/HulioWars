extends Node2D

var player
var visuals
var facing
var old_facing 

func _ready():
	player = get_parent()
	visuals = player.get_node("Visuals")

func _process(delta):
	pass
