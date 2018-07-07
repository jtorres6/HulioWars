extends KinematicBody2D

const MAX_SPEED = 300
const DAMAGE = 20

var life
var alerted
var currentEnemy
var onHitDelay
var nav 
var rol

func _ready():
	set_process(true)
	nav = get_parent().get_node("Navigation2D")
	#rol = randi()%2 # TODO: MAke it balanced more enemyes tan colleges
	rol = 1
	onHitDelay = false
	alerted = false
	life = 100

func _process(delta):
	
	# Si el jugador esta en el radio de alerta del npc, ir a por el
	if alerted:
		print(currentEnemy.position)
		var path = nav.get_simple_path(self.position, currentEnemy.position, false)
		
		if path.size() > 0:
			var dist = self.position.distance_to(path[1])
			self.set_position(self.position.linear_interpolate(path[1], (MAX_SPEED*delta)/dist))
	

func _on_Timer_timeout():
	onHitDelay = false


func _on_Colision_body_entered(body):	
	if body.name == "Player" and !onHitDelay and self.rol != body.rol: # == Player is unusefull
		body.life -= DAMAGE
		onHitDelay = true
		get_node("Timer").start()
	elif body.name.find("Projectile") != -1:
		self.life -= body.damage
		body.queue_free()


func _on_ScapeArea_body_exited(enemy):
	print("Bye ", enemy.name)
	if enemy == currentEnemy:
		alerted = false


func _on_AlertArea_body_entered(enemy):
	print("Hello ", enemy.name)
	if enemy.rol != self.rol:
		alerted = true
		currentEnemy = enemy
