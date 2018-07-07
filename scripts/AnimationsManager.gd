extends Node2D

# class member variables go here, for example:
var logicRoot
var visuals
var currentAnimation = 0
var animations = []
var inverted = false

func _ready():
	logicRoot = get_parent()
	visuals = logicRoot.get_node('Visuals/Bueno')
	animations.append(visuals.get_node('Lateral'))
	animations.append(visuals.get_node('45UP'))
	animations.append(visuals.get_node('45DOWN'))
	animations.append(visuals.get_node('UP'))
	animations.append(visuals.get_node('DOWN'))
	
func SelectAnimation():
	for i in range(animations.size()):
		if i == currentAnimation:
			animations[i].visible = true
		else:
			animations[i].visible = false

func _process(delta):
	var rotAngle = logicRoot.get_node('Weapon').playerAngle
		
	if -22.5 < rotAngle and rotAngle < 22.5:
		currentAnimation = 0
		inverted = false
	elif -67.5 < rotAngle and rotAngle < -22.5:
		currentAnimation = 1
		inverted = false
	elif -112.5 < rotAngle and rotAngle < -67.5:
		currentAnimation = 3
		inverted = false
	elif -157.5 < rotAngle and rotAngle < -112.5:
		currentAnimation = 1
		inverted = true
	elif 22.5 < rotAngle and rotAngle < 67.5:
		currentAnimation = 2
		inverted = false
	elif 67.5 < rotAngle and rotAngle < 112.5:
		currentAnimation = 4
		inverted = false
	elif 112.5 < rotAngle and rotAngle < 157.5:
		currentAnimation = 2
		inverted = true
	elif rotAngle < -157.5 or rotAngle > 157.5:
		currentAnimation =  0
		inverted = true
		
	SelectAnimation()
	
	if inverted:
		get_parent().facing_direction = -1
		animations[currentAnimation].flip_h = true
	else:
		get_parent().facing_direction = 1
		animations[currentAnimation].flip_h = false
		
		
