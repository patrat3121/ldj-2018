extends TextureRect

const Colors = preload("res://scripts/Colors.gd")

var health = []
var totalHealth = 0
var tileSize = 0
	
func setHealth(health):
	var total = 0
	for color in health:
		total += color.value
		
	self.health = health
	totalHealth = total
	
	tileSize = ceil(rect_size.x/ totalHealth)
	
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