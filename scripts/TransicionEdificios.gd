extends Node2D

var time = 20
var day = true
var start
var end

func _ready():
	$Timer.wait_time = 30
	$Timer.start()
	get_node("Iluminacion").enabled = false
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
	if day:
		$Sprite3.modulate[3] = 0.0
		if $Timer.time_left < 20:
			#$Sprite1.modulate[3] = 1.0*$Timer.time_left /20.0
			$Sprite2.modulate[3] = (1.0 - 1.0*$Timer.time_left /20.0)
		else:
			#$Sprite1.modulate[3] = 1.0
			$Sprite2.modulate[3] = 0.0
	else:
		if $Timer.time_left <= $Timer.wait_time - 5:
			$Sprite3.modulate[3] = 1.0
			$Iluminacion.enabled = true
			
		if $Timer.time_left < 20:
			$Sprite3.modulate[3] = 1.0*$Timer.time_left /20.0
			$Iluminacion.energy = 1.0*$Timer.time_left /20.0
			#$Sprite1.modulate[3] = (1.0 - 1.0*$Timer.time_left /20.0)
			
			if $Timer.time_left < 10:
				$Sprite3.modulate[3] = 0.0
				$Sprite2.modulate[3] = 1.0*$Timer.time_left /20.0
				$Iluminacion.enabled = false
				#$Sprite1.modulate[3] = (1.0 - 1.0*$Timer.time_left /20.0)
				
			
			
		
	"""
	get_node("Sprite1").material.set_shader_param("time", $Timer.time_left)
	get_node("Sprite1").material.set_shader_param("day", day)
	get_node("Sprite2").material.set_shader_param("time", $Timer.time_left)
	get_node("Sprite2").material.set_shader_param("day", day)
	get_node("Sprite3").material.set_shader_param("time", $Timer.time_left)
	get_node("Sprite3").material.set_shader_param("day", day)
	get_node("Iluminacion").material.set_shader_param("time", $Timer.time_left)
	get_node("Iluminacion").material.set_shader_param("day", day)
	
	start = randf()*$Timer.wait_time
	end = start + randf()*($Timer.wait_time-start)
	
	if day == false and $Timer.time_left < $Timer.wait_time - 5:
		get_node("Sprite1").material.set_shader_param("light", true)
		get_node("Sprite2").material.set_shader_param("light", true)
		get_node("Sprite3").material.set_shader_param("light", true)
		get_node("Iluminacion").enabled = true
	
	if day == false and $Timer.time_left < 7:
		get_node("Sprite1").material.set_shader_param("light", false)
		get_node("Sprite2").material.set_shader_param("light", false)
		get_node("Sprite3").material.set_shader_param("light", false)
		get_node("Iluminacion").enabled = false
	#get_node("Sprite2").material.set_shader_param("time", $Timer.time_left, "day", day)
	print($Timer.time_left)
	"""
	
	pass
	
func _on_Timer_timeout():
	day = !day
	$Timer.start()
	pass # replace with function body
