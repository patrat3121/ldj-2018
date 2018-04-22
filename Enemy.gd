extends KinematicBody2D

var Colors = preload("res://scripts/Colors.gd")

export (int) var speed = 125
export (Color) var color = Color(1,0,0)

const GRAVITY = 200

var velocity = Vector2()
var direction = 1
var health = StackHealthBar.new()

func _ready():
	pass
	
func start(pos, col, health):
	position = pos
	$Sprite.modulate = Colors.COLORS[col]
	collision_layer = 1 | Colors.COLORS_LAYER[col]
	self.health.init(health)
	$Node2D/HealthBar.setHealth(self.health.health)
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY 
	velocity.x = direction * speed
	
	move_and_slide(velocity, Vector2(0, -1))
	$Sprite.flip_h = velocity.x > 0
	
	if is_on_wall():
		direction = direction * -1

class StackHealthBar:
	var health = []

	func init(health):
		self.health = health

	func isDead():
		return health.size() == 0

	func push(item):
		if isDead():
			return

		if health[0].name == item.name:
			_calculateDamage(item)
			return

		for color in health:
			if color.name == item.name:
				color.value += item.damage
				return

	func _calculateDamage(item):
		health[0].value -= item.damage
		
		if health[0].value <= 0:
			health.pop_front()	