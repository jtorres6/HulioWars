extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time = 20
var day = false

func _ready():
	$Timer.wait_time = 30
	$Timer.start()
	get_node("Node2D/Light2D").energy = 1.0
	print(time)
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	
	if day:
		if $Timer.time_left > 20:
			get_node("Node2D/Light2D").energy = 1.0
		else:
			get_node("Node2D/Light2D").energy = 1.0 * $Timer.time_left/time
	else:
		if $Timer.time_left > 20:
			get_node("Node2D/Light2D").energy = 0.0
		else:
			get_node("Node2D/Light2D").energy = 1.0 - $Timer.time_left/time		
		
	pass


func _on_Timer_timeout():
	day = !day
	$Timer.start()
	pass # replace with function body
