extends Node2D

# class member variables go here, for example:
var logicRoot
var visuals
var currentAnimation = 0
var animations = []
var badAnimations = []
var inverted = false

func _ready():
	logicRoot = get_parent()
	visuals = logicRoot.get_node('Visuals/Bueno')
	animations.append(visuals.get_node('Lateral'))
	animations.append(visuals.get_node('45UP'))
	animations.append(visuals.get_node('45DOWN'))
	animations.append(visuals.get_node('UP'))
	animations.append(visuals.get_node('DOWN'))
	visuals = logicRoot.get_node('Visuals/Malo')
	badAnimations.append(visuals.get_node('Lateral2'))
	badAnimations.append(visuals.get_node('45UP2'))
	badAnimations.append(visuals.get_node('45DOWN2'))
	badAnimations.append(visuals.get_node('UP2'))
	badAnimations.append(visuals.get_node('DOWN2'))
	
func SelectAnimation():
	for i in range(animations.size()):
		animations[i].visible = false
		badAnimations[i].visible = false
	
	if logicRoot.get_parent().get_node('DayNightManager').day:
		for i in range(animations.size()):
			if i == currentAnimation:
				animations[i].visible = true
			else:
				animations[i].visible = false
	else:
		for i in range(animations.size()):
			if i == currentAnimation:
				badAnimations[i].visible = true
			else:
				badAnimations[i].visible = false
		
		
func _process(delta):
	var rotAngle = logicRoot.get_node('Weapon').playerAngle
	
	if -22.5 < rotAngle and rotAngle < 22.5:
		currentAnimation = 0
		inverted = false
		logicRoot.get_node('Weapon/Sprite').z_index = 0
	elif -67.5 < rotAngle and rotAngle < -22.5:
		currentAnimation = 1
		inverted = false
		logicRoot.get_node('Weapon/Sprite').z_index = -1
	elif -112.5 < rotAngle and rotAngle < -67.5:
		currentAnimation = 3
		inverted = false
		logicRoot.get_node('Weapon/Sprite').z_index = -1
	elif -157.5 < rotAngle and rotAngle < -112.5:
		currentAnimation = 1
		inverted = true
		logicRoot.get_node('Weapon/Sprite').z_index = -1
	elif 22.5 < rotAngle and rotAngle < 67.5:
		currentAnimation = 2
		inverted = false
		logicRoot.get_node('Weapon/Sprite').z_index = 0
	elif 67.5 < rotAngle and rotAngle < 112.5:
		currentAnimation = 4
		inverted = false
		logicRoot.get_node('Weapon/Sprite').z_index = 0
	elif 112.5 < rotAngle and rotAngle < 157.5:
		currentAnimation = 2
		inverted = true
		logicRoot.get_node('Weapon/Sprite').z_index = 0
	elif rotAngle < -157.5 or rotAngle > 157.5:
		currentAnimation =  0
		inverted = true
		logicRoot.get_node('Weapon/Sprite').z_index = 0
		
	SelectAnimation()
	
	if inverted:
		get_parent().facing_direction = -1
		animations[currentAnimation].flip_h = true
		badAnimations[currentAnimation].flip_h = true
	else:
		get_parent().facing_direction = 1
		animations[currentAnimation].flip_h = false
		badAnimations[currentAnimation].flip_h = false
		
		
		
