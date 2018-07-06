extends KinematicBody2D

var player


var life = 100
var MAX_SPEED = 100

var heColisionado
var alerted = false
var currentEnemy


func _ready():
	set_process(true)
	heColisionado = false

func _process(delta):
	player = get_parent().get_node("Player")
	
	# Si el jugador esta en el radio de alerta del npc, ir a por el
	if alerted:
		print("Alertttttt")
	

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
