extends KinematicBody2D

#************* Player Parameters: ******************

var life = 100
var rol = 0
var scoreBoard = 0
var score = [0, 0]

#******** Direction and facing stuff ***************

var input_direction = Vector2()
var direction = Vector2()
var facing_direction = 1

#********** Movement Parameters *********************

var speed_x = 0
var speed_y = 0
var velocity = Vector2()
const MAX_SPEED = 500
const ACCELERATION = 1200
const DECELERATION = 2000

#********** Another control params *******************
const MOCHAZO_DAMAGE = 50
const BONUS_FRIEND = -30
const BONUS_ENEMY = 10

#*****************************************************

func _ready():
	input_direction.x = 0
	input_direction.y = 0
	direction.x = 0
	direction.y = 0

func _input(event):
	pass

func _physics_process(delta):

	# Check movement orientation:
	if input_direction.x:
		direction.x = input_direction.x
		
	if input_direction.y:
		direction.y = input_direction.y
			
	# y orientation:
	if Input.is_key_pressed(KEY_W):
		input_direction.y = -1
	elif Input.is_key_pressed(KEY_S):
		input_direction.y = 1
	else:
		input_direction.y = 0
	
	if Input.is_key_pressed(KEY_A):
		input_direction.x = -1
	elif Input.is_key_pressed(KEY_D):
		input_direction.x = 1
	else:
		input_direction.x = 0
	
	# Set x_speed:
	if input_direction.x == - direction.x:
		speed_x /= 3
	if input_direction.x:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
		
	# Set y_speed:
	if input_direction.y == - direction.y:
		speed_y /= 3
	if input_direction.y:
		speed_y += ACCELERATION * delta
	else:
		speed_y -= DECELERATION * delta

	# Limit speed to MAX value:
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	speed_y = clamp(speed_y, 0, MAX_SPEED)
	
	# Set velocity vector and move player:
	velocity.x = speed_x * direction.x
	velocity.y = speed_y * direction.y
	move_and_slide(velocity, Vector2(0,-1))
	
	get_parent().update_camera()


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
	pass # replace with function body

func _on_Area2D_body_entered(body):
	print("[Colision] ", body.name)
	if body.name.find("NPC") != -1:
		self.life -= body.DAMAGE
		body.onHitDelay = true
		body.heColisionado = true
		body.get_node("HitTimer").start()
		
		if self.life <= 0:
			print("MUERTOOOOOOOOOO") # replace with function body

func _on_MeleeAtack_body_entered(body):
	if body.name.find("NPC") != -1:
		body.life -= MOCHAZO_DAMAGE
		if body.life <= 0:
			get_parent().enemiesInMap -= 1
			body.queue_free()
			var scoreBonus
			
			if self.rol == self.rol:
				self.scoreBoard -= BONUS_FRIEND
				self.score[(self.rol+1)%2] += BONUS_ENEMY
			else:
				self.scoreBoard += BONUS_ENEMY
				self.score[self.rol] += BONUS_ENEMY
				
			print("ScoreBoard: ", self.scoreBoard)
			print("Score: ", self.score)
