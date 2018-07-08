extends Node2D

var mouse_position = Vector2()
var player
var bullet_scene
var canShot = true
var canMochazo = true
var playerAngle = 0

func _ready():
	bullet_scene = load('res://scenes/Projectile.tscn')
	player = get_parent()
	player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').disabled = true
	player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').visible = false  #for debug
	
	
func ParseToLocal(global_pos):
	var self_gtrans = self.get_global_transform()
	var local_pos = self_gtrans.xform_inv(global_pos)
	return local_pos
	
	
func InstanceBullet(shot_dir):
	shot_dir = shot_dir.normalized()
	var bullet = bullet_scene.instance()
	bullet.ydirection = shot_dir.y
	bullet.xdirection = shot_dir.x
	bullet.position = player.position
	player.get_node('ShootDelay').start()
	player.get_parent().add_child(bullet)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed() and canShot:
			canShot = false
			InstanceBullet(get_global_mouse_position() - player.position)
		elif event.button_index == BUTTON_RIGHT and event.is_pressed() and canMochazo:
			canMochazo = false
			player.get_node('MochazoDelay').start()
			player.get_node('MochazoTimer').start()
			player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').disabled = false
			player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').visible = true #for debug
			get_node('Sprite/AnimatedSprite').play()
			get_node('Sprite/AnimatedSprite').visible = true


func _process(delta):
	mouse_position = get_global_mouse_position()
	get_node("Sprite").look_at(mouse_position)
	var local_pos = ParseToLocal(mouse_position)
	var angle = rad2deg(local_pos.angle())
	playerAngle = angle
	
	
	if abs(angle) > 90:
		get_parent().facing_direction = -1
		get_node('Sprite').flip_v = true
		get_node("Sprite/AnimatedSprite").flip_v = true
	elif abs(angle) <= 90:
		get_parent().facing_direction = 1
		get_node('Sprite').flip_v = false
		get_node('Sprite/AnimatedSprite').flip_v = false

func _on_ShootDelay_timeout():
	canShot = true


func _on_MochazoDelay_timeout():
	canMochazo = true


func _on_MochazoTimer_timeout():
	player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').disabled = true
	player.get_node('Weapon/Sprite/MeleeAtack/CollisionPolygon2D').visible = false #for debug
	get_node('Sprite/AnimatedSprite').stop()
	get_node('Sprite/AnimatedSprite').visible = false
