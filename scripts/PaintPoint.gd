extends Area2D

signal color_changed

var colors = preload("res://scripts/Colors.gd")

func hit_by(body):
	modulate = colors.COLORS[body.color]
	emit_signal("color_changed",body.color)
	body.queue_free()
