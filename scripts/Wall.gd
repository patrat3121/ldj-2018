extends StaticBody2D

const colors = preload("res://scripts/Colors.gd")

export var current_color = "red"
export(NodePath) var paint_point = null 

func _ready():
	change_color(current_color)
	if(paint_point != null):
		var point = get_node(paint_point)
		point.connect("color_changed",self,"change_color")

func change_color(color):
	$sprite.modulate = colors.COLORS[color]
	current_color = color
	
func hit_by(body):
	change_color(body.color)
