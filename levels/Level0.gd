extends Node2D

var StaticEnemy = preload("res://scenes/StaticEnemy.tscn")
var MovingEnemy = preload("res://scenes/MovingEnemy.tscn")
export(Vector2) var spawn = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _enter_tree():
	
	var enemies = [
		{
			spawn = $EnemySpawn.position,
			health = [{
				name = "red",
				value = 3
			},{
				name = "blue",
				value = 2
			}],
			type = "moving"	
		},
		{
			spawn = $EnemySpawn2.position,
			health = [{
				name = "orange",
				value = 3
			},{
				name = "purple",
				value = 8
			}],
			type = "static"	
		}
	]
	
	for enemy in enemies:
		addEnemy(enemy)
	
func addEnemy(enemy):
	var iEnemy = getEnemyInstance(enemy.type)
	iEnemy.start(enemy.spawn, enemy.health)
	add_child(iEnemy)

func getEnemyInstance(type):
	match type:
		"static":
			return StaticEnemy.instance()
		"moving":
			return MovingEnemy.instance()
		_:
			return MovingEnemy.instance()
		
			