extends "res://scripts/Enemy.gd"

func logic(delta):
	velocity.y += delta * GRAVITY 
	velocity.x = direction * speed
	
	move_and_slide(velocity, Vector2(0, -1))
	$Sprite.flip_h = velocity.x > 0
	
	if is_on_wall():
		direction = direction * -1