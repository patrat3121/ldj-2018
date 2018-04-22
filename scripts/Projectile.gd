extends Area2D

export(int) var speed = 50
export(int) var damage = 1
export var color = "blue"

var colors = preload("res://scripts/Colors.gd")

func _ready():
	modulate = colors.COLORS[color]
	connect("area_entered",self,"_on_area_entered")
	connect("body_entered",self,"_on_area_entered")

func _process(delta):
	var direction = Vector2(cos(rotation),sin(rotation))
	position += delta * speed * direction
	$AnimatedSprite.play()

func _on_area_entered(body):
	if body.has_method("hit_by"):
		body.hit_by(self)

func hit_by(body):
	pass