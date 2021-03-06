extends KinematicBody2D

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300

export var JUMP_SPEED = 300
export var JUMP_MAX_AIRBORNE_TIME = 0.2
export var SHOOT_LATENCY = 0.35

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel
const BUTTON_DISABLED_COLOR = Color(.7,.7,.7,.7)
const BUTTON_ENABLED_COLOR = Color(1,1,1,1)

var velocity = Vector2()
var looks_right = true	#orientation player is facing. Also, code is just looking right so far
var on_air_time = 100
var time_since_last_shot = 0.0
var jumping = false
var alive = true

var shot_color = "red"
var prev_jump_pressed = false
var colors = preload("res://scripts/Colors.gd")

var chosen_colors = []
var color_nodes = {}

func _ready():
	$CanvasLayer/HBoxContainer/red.modulate = BUTTON_DISABLED_COLOR
	$CanvasLayer/HBoxContainer/blue.modulate = BUTTON_DISABLED_COLOR
	$CanvasLayer/HBoxContainer/yellow.modulate = BUTTON_DISABLED_COLOR
	
func _enter_tree():
	for color in ["red", "blue", "yellow"]:
		color_nodes[color] = get_node("CanvasLayer/HBoxContainer/" + color)

func _physics_process(delta):
	if !alive:
		return
	
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	var suicide = Input.is_action_pressed("suicide")
	var chose_red = Input.is_action_just_pressed("load_red")
	var chose_blue = Input.is_action_just_pressed("load_blue")
	var chose_yellow = Input.is_action_just_pressed("load_yellow")
	
	var stop = true
	
	if walk_left:
		looks_right = false
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		looks_right = true
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	if (suicide):
		alive = false
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	time_since_last_shot += delta
	if shoot and time_since_last_shot>SHOOT_LATENCY:
		# Can't shoot continuously, must wait SHOOT_LATENCY seconds first
		shoot()
		
	if chose_red:
		select_color("red")
	if chose_blue:
		select_color("blue")
	if chose_yellow:
		select_color("yellow")

func select_color(color):
	var cIndex = chosen_colors.find(color)
	
	if cIndex == -1:
		color_nodes[color].modulate = BUTTON_ENABLED_COLOR
		chosen_colors.push_back(color)
	else:
		color_nodes[color].modulate = BUTTON_DISABLED_COLOR
		chosen_colors.remove(cIndex)
	

func _process(delta):
	if alive:
		if !is_on_floor():
			$AnimatedSprite.animation = "jumping"
		elif velocity.x==0:
			$AnimatedSprite.animation = "idle"
		elif $AnimatedSprite.animation!="running":
			$AnimatedSprite.animation = "running"
	elif $AnimatedSprite.animation != "death":
		$AnimatedSprite.animation = "death"
	
	
	$AnimatedSprite.flip_h = !looks_right
	$AnimatedSprite.play()

func run():
	pass

func get_shot_color():
	return colors.get_shot_color(chosen_colors)

func shoot():
	time_since_last_shot = fmod(time_since_last_shot,SHOOT_LATENCY)
	var projectile = preload("res://scenes/Projectile.tscn")
	var projectile_instance = projectile.instance()
	var mouse = get_global_mouse_position()
	var start = position
	var shot_color = get_shot_color()
	
	if shot_color == null:
		return
	
	projectile_instance.rotation_degrees = -rad2deg((mouse-start).angle_to(Vector2(1,0)))
	get_parent().add_child(projectile_instance)
	projectile_instance.position = Vector2(self.position.x,self.position.y)
	projectile_instance.speed = 50
	projectile_instance.color = shot_color
	projectile_instance.modulate = colors.COLORS[shot_color]
	projectile_instance.damage = 1
	projectile_instance.show()
	$AnimatedSprite.animation = "shooting"
		
func hit_by(body):
	pass