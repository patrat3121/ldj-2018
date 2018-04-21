extends Area2D

signal color_changed

var colors = preload("res://scripts/Colors.gd")

func _ready():
	connect("area_entered",self,"_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	modulate = colors.COLORS[body.color]
	emit_signal("color_changed",body.color)
