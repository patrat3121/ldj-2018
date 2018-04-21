extends Object

const COLORS = {
	"red" : Color(1,0,0),
	"blue": Color(0,0,1),
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

static func is_contained(one,two):
	return CONTAINED[one].has(two)
	
static func subtract(one,two):
	var color = CONTAINED[one]
	return color.remove(color.find_last(two))
