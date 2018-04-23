extends "res://scripts/Enemy.gd"

var player
var Projectile = preload("res://scenes/Projectile.tscn")
var time_since_last_shot = 0.0

var fire_interval = 2

func _ready():
	player = get_node("../Player")
	._ready()

func logic(delta):
	time_since_last_shot += delta
	if time_since_last_shot > fire_interval:
		shoot()

func shoot():
	time_since_last_shot = fmod(time_since_last_shot, fire_interval)
	
	#face player
	var start = position
	var projectile = Projectile.instance()
	projectile.type = "enemy_projectile"
	projectile.rotation_degrees = -rad2deg((player.position-start).angle_to(Vector2(1,0)))
	
	#shoot
	if abs(projectile.rotation_degrees) <= 90:
		projectile.position += Vector2(25, 0)
		$Sprite.flip_h = true
	else :
		projectile.position += Vector2(-25, 0)
		$Sprite.flip_h = false
	add_child(projectile)