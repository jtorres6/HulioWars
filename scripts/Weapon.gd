extends Node2D

var mouse_position = Vector2()
var player
var bullet_scene
var canShot = true

func _ready():
	bullet_scene = load('res://scenes/Projectile.tscn')
	player = get_parent()
	
	
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
	if event is InputEventMouseMotion:
       mouse_position = event.position
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			InstanceBullet(event.position - player.position)


func _process(delta):
	get_node("Sprite").look_at(mouse_position)
	var local_pos = ParseToLocal(mouse_position)
	var angle = abs(rad2deg(local_pos.angle()))
	
	if angle > 90:
		get_parent().facing_direction = -1
		get_node('Sprite').flip_v = true
	elif angle <= 90:
		get_parent().facing_direction = 1
		get_node('Sprite').flip_v = false

func _on_ShootDelay_timeout():
	canShot = true
