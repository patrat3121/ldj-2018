extends TextureRect

const Colors = preload("res://scripts/Colors.gd")

var health = []
var totalHealth = 0
var tileSize = 0
var initHealth = 0
	
func initHealth(health):
	_setHealth(health, true)
	
func setHealth(health):
	_setHealth(health, false)	
	
func _setHealth(health, init):
	var total = 0
	for color in health:
		total += color.value
		
	if init == true:
		initHealth = total
	
	self.health = health
	totalHealth = total
	
	if totalHealth >= initHealth:
		tileSize = ceil(rect_size.x / totalHealth)
	else:
		tileSize = ceil(rect_size.x / initHealth) 
	
	update()
	
func _draw():
	draw_rect(
		Rect2(rect_position, rect_size),
		Color(.4,.4,.4)
	)

	var iLength = 0
	for color in health:
		var barLength = color.value * tileSize
		var barStart
		if iLength > 0:
			barStart = iLength
		else: 
			barStart = 0 
			
		iLength += barLength 
	
		draw_rect(
			Rect2(
				rect_position + Vector2(barStart, 0), 
				Vector2(barLength, rect_size.y)
			),
			Colors.COLORS[color.name]
		)
		
		for i in range(1, color.value):
			draw_line(
				Vector2(barStart + i*tileSize, rect_position.y),
				Vector2(barStart + i*tileSize, rect_position.y + rect_size.y),
				Color(0, 0, 0)
			)