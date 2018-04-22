extends KinematicBody2D

var Colors = preload("res://scripts/Colors.gd")

export (int) var speed = 0
export var color = "red"

const GRAVITY = 200

var velocity = Vector2()
var direction = 1
var health = StackHealthBar.new()

func _ready():
	pass
	
func start(pos, health):
	position = pos
	set_color(health[0].name)
	self.health.init(health)
	$Node2D/HPBar/HP.initHealth(self.health.health)
	
func set_color(color):
	self.color = color
	$Sprite.modulate = Colors.COLORS[color]
	collision_layer = 1 | Colors.COLORS_LAYER[color]
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY 
	velocity.x = direction * speed
	
	move_and_slide(velocity, Vector2(0, -1))
	$Sprite.flip_h = velocity.x > 0
	
	if is_on_wall():
		direction = direction * -1
		
func hit_by(body):
	health.push({ name = body.color, damage = body.damage})
	
	if health.is_dead():
		hide()
		queue_free()
	else:
		if health.health[0].name != color:
			set_color(health.health[0].name)
		$Node2D/HPBar/HP.setHealth(health.health)

class StackHealthBar:
	var health = []

	func init(health):
		self.health = health

	func is_dead():
		return health.size() == 0

	func push(item):
		if is_dead():
			return

		if health[0].name == item.name:
			_calculateDamage(item)
			return

		for color in health:
			if color.name == item.name:
				color.value += item.damage
				return
		
		health.push_back({ name = item.name, value = item.damage })

	func _calculateDamage(item):
		health[0].value -= item.damage
		
		if health[0].value <= 0:
			health.pop_front()
