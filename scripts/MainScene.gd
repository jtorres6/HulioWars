
# Custom camera
extends Node2D

# Getting globals (values from the Scene menu -> Project Settings). An alternative is OS.get_window_size()
onready var screen_size = OS.get_window_size()
onready var player = get_node("Player")

var enemiesInMap = 0


const spawnZones = [[-1440, 700], [960, 700], [960, 960], [-1400, 960], [-1600, 0], [0, 1000]]
const maxEnemiesInMap = 20

func _ready():
	# Initializes the camera, sets its position to that of the player
	update_camera()
	$SpawnTimer.start()
	# Instead of connecting the signal from the editor, we can do this via code. We connect from the player (using the player variable) to the camera (the self argument below).
	# However, I prefer to do this in the editor as it'll display an icon, making it easy to spot connections later
	# player.connect("move", self, "update_camera")
	

	
# Center the camera on the player. Automatically called when the player moves.
func update_camera():
	var canvas_transform = get_viewport().get_canvas_transform()
	# canvas_transform is of type Matrix32. That's an array of 3 Vector2, and canvas_transform[2] controls the canvas's offset.
	# Moving a camera isn't moving a camera per se, instead we move the canvas (all the sprites) under the camera. That's why we use -1*player.get_pos()
	canvas_transform[2] = -player.position+ screen_size / 2
	get_viewport().set_canvas_transform(canvas_transform)

func _on_SpawnTimer_timeout():
	if enemiesInMap < maxEnemiesInMap:
		var npc = load("res://scenes/NPC.tscn")
		var newNpc = npc.instance()
		var randIndx = randi()%spawnZones.size()
		var rndPos = spawnZones[randIndx]
		
		newNpc.position = RandomPosition(Vector2(rndPos[0], rndPos[1]))
		newNpc.originalPosition = newNpc.position
		
		self.add_child(newNpc)
		enemiesInMap += 1


func RandomPosition(originalPos):
	var rndX = randi()%30+5
	var rndY = randi()%30+5
	var neg1 = randi()%2
	var neg2 = randi()%2
	
	if neg1 == 0:
		rndX *= -1
		
	if neg2 == 0:
		rndY *= -1
	
	var goalX = originalPos.x + rndX
	var goalY = originalPos.y + rndY
	
	return Vector2(goalX, goalY)