extends Area2D

export(NodePath) var spawn_point = null

func _ready():
	connect("body_entered",self,"_on_area_entered")

func _on_area_entered(body):
	if(body.get_name() == "Player"):
		body.position = get_node(spawn_point).position
