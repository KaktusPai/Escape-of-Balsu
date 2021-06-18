extends KinematicBody2D

# Movement variables
export var velocity = Vector2(0,0)
const SPEED = 180
export var slowDownWeight = 0.2

# Essentially like Update() in Unity, updates 60fps
func _physics_process(delta):
	if Input.is_action_just_pressed("right"): # If D or RIGHTARROW, go right
		velocity.x = SPEED
	if Input.is_action_just_pressed("left"): # If A or LEFTARROW, go left
		velocity.x = -SPEED
	
	velocity.y = velocity.y + 30
	
	velocity = move_and_slide(velocity)
	
	velocity.x = lerp(velocity.x,0,0.1)
