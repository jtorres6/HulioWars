extends KinematicBody2D

const MAX_SPEED = 300
const DAMAGE = 20
const BONUS_FRIEND = -30
const BONUS_ENEMY = 10

var life
var alerted
var comeback
var walkAround
var walkAroundSpeed = Vector2()
var currentEnemy
var onHitDelay
var onWalkDelay
var nav 
var rol
var originalPosition
var heColisionado

func _ready():
	set_process(true)
	nav = get_parent().get_node("Navigation2D")
	onHitDelay = false
	onWalkDelay = false
	alerted = false
	comeback = false
	walkAround = true
	heColisionado = false
	life = 100
	
	var rnd = randi()%4 # TODO: Make it balanced more enemyes tan colleges
	if get_parent().get_node("DayNightManager").day:
		if rnd < 2:
			rol = 1 # Si es de dia, es mas probable ser punky
		else:
			rol = 0
	else:
		if rnd < 2:
			rol = 0 # Si es de noche, es mas probable ser poli
		else:
			rol = 1
	
	originalPosition = self.position
	
	if rol == 0:
		self.get_node("Visuals/Poli").visible = true
		self.get_node("Visuals/Poli/PoliPorra").visible = true
		self.get_node("Visuals/Punky").visible = false
		self.get_node("Visuals/Punky/PunkyPorra").visible = false
	else:
		self.get_node("Visuals/Poli").visible = false
		self.get_node("Visuals/Poli/PoliPorra").visible = false
		self.get_node("Visuals/Punky").visible = true
		self.get_node("Visuals/Punky/PunkyPorra").visible = true


func _physics_process(delta):
	var playerPos = get_parent().get_node("Player").position
	var goal
	# Si el jugador esta en el radio de alerta del npc, ir a por el
	if heColisionado:
		var xdir = (playerPos.x - position.x)
		var ydir = (playerPos.y - position.y)
		var speedx = abs((playerPos.x - position.x))
		var speedy = abs((playerPos.y - position.y))
		speedx = clamp(speedx, 0, MAX_SPEED)
		speedy = clamp(speedy, 0, MAX_SPEED)
		
		speedx = speedx * (-1 if xdir < 0 else 1) * delta
		speedy = (speedy+25) * (-1 if ydir < 0 else 1) * delta
		
		move_and_collide(Vector2(speedx, speedy) * -1)
		
		return
	elif alerted:
		goal = currentEnemy.position
	
		if currentEnemy.rol == self.rol:
			alerted = false
			comeback = true
			currentEnemy = null
	      
	elif comeback:    
		goal = originalPosition
	
	if alerted or comeback or walkAround:
		var path = [position]
	
		if walkAround:
			if randf() < 0.01:
				walkAroundSpeed.x = rand_range(-1, 1) * 4000 * delta
				walkAroundSpeed.y = rand_range(-1, 1) * 4000 * delta
			move_and_slide(walkAroundSpeed)
		else:
			path = nav.get_simple_path(self.position, goal, false)
		
			if path.size() > 0:
				for i in range(1, path.size()):
					var dist = self.position.distance_to(path[i])
		    
					if dist > 0:
						self.set_position(self.position.linear_interpolate(path[i], (MAX_SPEED*delta)/dist))
		    
					if comeback and dist < 5:
						comeback = false
						walkAround = true


func _on_Colision_body_entered(body):	
	if body.name.find("Projectile") != -1:
		self.life -= body.damage
		body.queue_free()
		
		if self.life <= 0:
			get_parent().enemiesInMap -= 1
			self.queue_free()
			var scoreBonus
			var player = get_parent().get_node("Player")
			
			if player.rol == self.rol:
				player.scoreBoard -= BONUS_FRIEND
				player.score[(player.rol+1)%2] += BONUS_ENEMY
			else:
				player.scoreBoard += BONUS_ENEMY
				player.score[player.rol] += BONUS_ENEMY
				
			print("ScoreBoard: ", player.scoreBoard)
			print("Score: ", player.score)
	
#	elif body.name == "Player" and !onHitDelay and self.rol != body.rol: # == Player is unusefull
#		body.life -= DAMAGE
#		onHitDelay = true
#		get_node("HitTimer").start()


func _on_ScapeArea_body_exited(enemy):
	if enemy == currentEnemy:
		currentEnemy = null
		alerted = false
		walkAround = false
		comeback = true


func _on_AlertArea_body_entered(enemy):
	if enemy.name == "Player" and enemy.rol != self.rol:
		currentEnemy = enemy
		alerted = true
		comeback = false
		walkAround = false


func RandomGoal(originalPos):
	var rndX = randi()%2400+1000
	var rndY = randi()%2400+1000
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
	heColisionado = false

func _on_RndWalkTimer_timeout():
	onWalkDelay = false
