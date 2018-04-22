extends Area2D

export(int) var speed = 50
export var color = "blue"

var colors = preload("res://scripts/Colors.gd")

func _ready():
	modulate = colors.COLORS[color]
	connect("area_entered",self,"_on_area_entered")

func _process(delta):
	var direction = Vector2(cos(rotation),sin(rotation))
	position += delta * speed * direction

func _on_area_entered(body):
	body.hit_by(self)