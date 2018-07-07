extends Node2D

var time = 20
var day = true
var start
var end

func _ready():
	$Timer.wait_time = 30
	$Timer.start()
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	get_node("Sprite1").material.set_shader_param("time", $Timer.time_left)
	get_node("Sprite1").material.set_shader_param("day", day)
	get_node("Sprite2").material.set_shader_param("time", $Timer.time_left)
	get_node("Sprite2").material.set_shader_param("day", day)

	pass
	
func _on_Timer_timeout():
	day = !day
	$Timer.start()
	pass # replace with function body
