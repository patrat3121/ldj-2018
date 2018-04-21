extends Area2D

export(int) var speed = 50
export var color = "blue"

var colors = preload("res://scripts/Colors.gd")

func _ready():
	modulate = colors.COLORS[color]

func _process(delta):
	var direction = Vector2(cos(rotation),sin(rotation))
	position += delta * speed * direction
