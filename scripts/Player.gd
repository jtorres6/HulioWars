extends KinematicBody2D

#************* Player Parameters: ******************

var life = 100

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

# var canIShoot

#*****************************************************

func _ready():
	input_direction.x = 0
	input_direction.y = 0
	direction.x = 0
	direction.y = 0

func _input(event):
	pass

""" FUTURE POSSIBLE USE?
func InstanceBullet():
	# FIXME:
	var bullet = ammoArray[currentAmmo].instance()
	bullet.ydirection = y_orientation
	
	if y_orientation:
		bullet.xdirection = 0
	else:
		bullet.xdirection = facing_direction

	bullet.position = self.position
	$ShootDelay.wait_time = bullet.delay
	get_parent().add_child(bullet)
	$ShootDelay.start()
"""

func _physics_process(delta):

	# Check movement orientation:
	if input_direction.x:
		direction.x = input_direction.x
		facing_direction = input_direction.x
		
	if input_direction.y:
		direction.y = input_direction.y
			
	# y orientation:
	if Input.is_action_pressed('ui_up'):
		input_direction.y = -1
	elif Input.is_action_pressed('ui_down'):
		input_direction.y = 1
	else:
		input_direction.y = 0
	
	if Input.is_action_pressed("ui_left"):
		input_direction.x = -1
	elif Input.is_action_pressed("ui_right"):
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
	velocity.x = speed_x * direction
	velocity.y = speed_y * direction
	move_and_slide(velocity, Vector2(0,-1))
	
"""
	# Shoot
	if Input.is_action_pressed('ui_shoot') and canIShoot:
		canIShoot = false
		InstanceBullet()
	

func _on_ShootDelay_timeout():
	canIShoot = true
"""
