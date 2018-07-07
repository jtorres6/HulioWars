extends KinematicBody2D

const MAX_SPEED = 300
const DAMAGE = 20

var life
var alerted
var comeback
#var walkAround
var currentEnemy
var onHitDelay
var onWalkDelay
var nav 
var rol
var originalPosition

func _ready():
	set_process(true)
	nav = get_parent().get_node("Navigation2D")
	rol = randi()%2 # TODO: Make it balanced more enemyes tan colleges
	onHitDelay = false
	onWalkDelay = false
	alerted = false
	comeback = false
#	walkAround = true
	life = 100
	
	originalPosition = self.position
	
	if rol == 0:
		self.get_node("Visuals/Sprite").texture = load("res://sprites/npc/police/police1.png")
	else:
		self.get_node("Visuals/Sprite").texture = load("res://sprites/npc/punk/punk1.png")


func _process(delta):
	var goal
	
	# Si el jugador esta en el radio de alerta del npc, ir a por els
	if alerted:
		goal = currentEnemy.position
	elif comeback:		
		goal = originalPosition
#	elif walkAround and !onWalkDelay:
#		goal = RandomGoal(position)
#		print(goal)

	if alerted or comeback: # (walkAround and !onWalkDelay)
		var path = nav.get_simple_path(self.position, goal, false)
		
		if path.size() > 0:
			for i in range(1, path.size()):
				var dist = self.position.distance_to(path[i])
				self.set_position(self.position.linear_interpolate(path[i], (MAX_SPEED*delta)/dist))
				
				if comeback and dist < 0.01:
					comeback = false
#					walkAround = true
#				elif walkAround:
#					onWalkDelay = true
#					get_node("RndWalkTimer").start()


func _on_Colision_body_entered(body):	
	if body.name.find("Projectile") != -1:
		self.life -= body.damage
		body.queue_free()
		
		if self.life <= 0:
			self.queue_free()
	
	elif body.name == "Player" and !onHitDelay and self.rol != body.rol: # == Player is unusefull
		body.life -= DAMAGE
		onHitDelay = true
		get_node("HitTimer").start()


func _on_ScapeArea_body_exited(enemy):
	print("Bye ", enemy.name)
	if enemy == currentEnemy:
		currentEnemy = null
		alerted = false
#		walkAround = false
		comeback = true


func _on_AlertArea_body_entered(enemy):
	print("Hello ", enemy.name)
	if enemy.rol != self.rol:
		currentEnemy = enemy
		alerted = true
		comeback = false
#		walkAround = false


func RandomGoal(originalPos):
	var rndX = randi()%1500+300
	var rndY = randi()%1500+300
	var neg1 = randi()%2
	var neg2 = randi()%2
	
	if neg1 == 0:
		rndX *= -1
		
	if neg2 == 0:
		rndY *= -1
	
	var goalX = position.x + rndX
	var goalY = position.y + rndY
	
	return Vector2(goalX, goalY)

func _on_HitTimer_timeout():
	onHitDelay = false

func _on_RndWalkTimer_timeout():
	onWalkDelay = false
