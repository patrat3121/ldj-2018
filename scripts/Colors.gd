extends Object

const COLORS = {
	"red" : Color(1,0,0),
	"blue": Color(0,0,.7),
	"yellow" : Color(1,1,0),
	"green" : Color(0,1,0),
	"purple" : Color(1,0,1),
	"orange" : Color(1,0.25,0)
}

const CONTAINED = {
	"red" : ["red"],
	"blue": ["blue"],
	"yellow" : ["yellow"],
	"green" : ["yellow","blue"],
	"purple" : ["blue","red"],
	"orange" : ["red","yellow"]
}

const COLORS_LAYER = {
	"red" : 2,
	"blue": 4, 
	"yellow": 8,
	"green" : 16,
	"purple" : 32,
	"orange" : 64
}

static func is_contained(one,two):
	return CONTAINED[one].has(two)
	
static func subtract(one,two):
	var color = CONTAINED[one].duplicate()
	color.remove(color.find_last(two))
	return color

static func get_shot_color(colors):
	if colors.size() == 1:
		return colors[0]
	
	for color in CONTAINED:
		var res = true
		
		if CONTAINED[color].size() == 1:
			continue
		
		for sub_color in CONTAINED[color]:
			if not colors.has(sub_color):
				res = false
				break
				
		if res == true:
			return color