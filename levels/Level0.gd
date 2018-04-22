extends Node2D

var Enemy = preload("res://scenes/Enemy.tscn")
export(Vector2) var spawn = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _enter_tree():
	var enemy = Enemy.instance()
	enemy.start(spawn, [{
		name = "red",
		value = 3
	},{
		name = "blue",
		value = 2
	}])
	add_child(enemy)
	