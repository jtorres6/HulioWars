extends Node2D

var time = 20
var day = true
var start
var end

func _ready():
	$Timer.wait_time = 60
	$Timer.start()
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
	if day:
		if $Timer.time_left < 20:
			#$Sprite1.modulate[3] = 1.0*$Timer.time_left /20.0
			$Sprite2.modulate[3] = (1.0 - 1.0*$Timer.time_left /20.0)
		else:
			#$Sprite1.modulate[3] = 1.0
			$Sprite2.modulate[3] = 0.0
	else:
		if $Timer.time_left < 20:
			$Sprite2.modulate[3] = 1.0*$Timer.time_left /20.0

	pass
	
func _on_Timer_timeout():
	day = !day
	$Timer.start()
	pass # replace with function body
