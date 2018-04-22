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
export var SHOOT_LATENCY = 0.5

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var looks_right = true	#orientation player is facing. Also, code is just looking right so far
var on_air_time = 100
var time_since_last_shot = 0.0
var jumping = false
var alive = true

var prev_jump_pressed = false

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

func shoot():
	print("Shot projectile")
	time_since_last_shot = fmod(time_since_last_shot,SHOOT_LATENCY)
	#TODO: Actually shoot projectile
	var projectile = preload("res://scenes/Projectile.tscn")
	var projectile_instance = projectile.instance()
	get_parent().add_child(projectile_instance)
	projectile_instance.position = Vector2(self.position.x,self.position.y)
	projectile_instance.color = "green"
	projectile_instance.speed = 50
	projectile_instance.damage = 1
	projectile_instance.show()
	$AnimatedSprite.animation = "shooting"
		
func hit_by(body):
	pass