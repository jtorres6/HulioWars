extends KinematicBody2D

var player


var life = 100
var MAX_SPEED = 350

var heColisionado
var alerted = false
var currentEnemy
var nav 


func _ready():
	set_process(true)
	heColisionado = false
	nav = get_parent().get_node("Navigation2D")

func _process(delta):
	
	# Si el jugador esta en el radio de alerta del npc, ir a por el
	if alerted:
		var enemy = get_parent().get_node("Player")
		var path = nav.get_simple_path(self.position, enemy.position, false)
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


func _on_AlertArea_area_entered(enemy):
	print("Hello")
	alerted = true
	currentEnemy = enemy
