extends Node2D

export var floor_y = -500
export var tile_length = 50

var tiles = [
	load("res://assets/tiles/grass-1.png"),
	load("res://assets/tiles/grass-2.png")
]
	
var tile = preload("res://scenes/Tile.tscn")

func _ready():
	make_floor(30)

func make_floor(length):
	for i in range(0,length):
		var instance = tile.instance()
		var sprite = instance.get_child(0)
		sprite.texture = tiles[rand_range(0,2)]
		instance.position.y = floor_y
		instance.position.x = tile_length/2 + (i * tile_length)
		add_child(instance)
