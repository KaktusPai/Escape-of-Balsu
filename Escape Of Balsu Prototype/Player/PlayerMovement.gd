extends KinematicBody2D

# Movement variables
export var velocity = Vector2(0,0)
export var slowDownWeight = 0.2
export var gravityDirection = Vector2.UP
const SPEED = 600
const GRAVITY = 40
const JUMPFORCE = -1100

# Essentially like Update() in Unity, updates 60fps
# warning-ignore:unused_argument
func _physics_process(delta):
	if Input.is_action_pressed("right"): # If D or RIGHTARROW, go right
		velocity.x = SPEED
	if Input.is_action_pressed("left"): # If A or LEFTARROW, go left
		velocity.x = -SPEED
	
	velocity.y = velocity.y + GRAVITY # Gravity
	
	if Input.is_action_just_pressed("jump") && is_on_floor(): # If W/SPACE, jump
		velocity.y = JUMPFORCE
	
	velocity = move_and_slide(velocity, gravityDirection) # Storing movement and gravity as velocity(x,y)
	
	velocity.x = lerp(velocity.x,0,slowDownWeight) # Subtle slide when stopping
