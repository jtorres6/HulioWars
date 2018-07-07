extends KinematicBody2D

const MAX_SPEED = 300
const DAMAGE = 20

var life
var alerted
var currentEnemy
var heColisionado
var nav 

func _ready():
	set_process(true)
	heColisionado = false
	alerted = false
	life = 100
	nav = get_parent().get_node("Navigation2D")

func _process(delta):
	
	# Si el jugador esta en el radio de alerta del npc, ir a por el
	if alerted:
		var path = nav.get_simple_path(self.position, currentEnemy.position, false)
		
		if path.size() > 0:
			var dist = self.position.distance_to(path[1])
			self.set_position(self.position.linear_interpolate(path[1], (MAX_SPEED*delta)/dist))
	

func _on_Area2D_body_entered(body):
	if not body.get("penetracion") == null:
		var penetracion = body.get("penetracion")
		life -= body.get("damage")
		get_parent().get_node("SoundEffects/HitCrown").play()
	
		if !penetracion:
			body.queue_free()
		
	if life <= 0:
		get_parent().get_node("RavenManager").contador_ravens -= 1
		queue_free()
		
	if body.name == "Player":
		if body.get("invencible") == false:
			body._hitPlayer(10)
			heColisionado = true
			get_node("Timer").start()
			get_parent().get_node("SoundEffects/HitPlayer").play()


func _on_Timer_timeout():
	heColisionado = false
	pass

func _on_Colision_body_entered(body):
	print("entra cuerpo ", body.name)
	print(body.name.find("Projectile"))
	
	if body.name == "Player":
		body.life -= DAMAGE
	elif body.name.find("Projectile") != -1:
		self.life -= body.damage
		body.queue_free()


func _on_ScapeArea_body_exited(enemy):
	print("Bye ", enemy.name)
	if enemy == currentEnemy:
		alerted = false


func _on_AlertArea_body_entered(enemy):
	print("Hello ", enemy.name)
	if enemy.name == "Player":
		alerted = true
		currentEnemy = enemy
