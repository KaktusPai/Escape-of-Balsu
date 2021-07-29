extends KinematicBody2D

# Movement variables
export var velocity = Vector2(0,0)
export var speed = 600
export var jumpForce = -1100
export var slowDownWeight = 0.2
export var flyingWithHookSpeed = 40
var turningStartRotation = 0
# Gravity variables
export var gravityDirection = Vector2.UP
export var gravity = 40
# States
const StateManagerReference = preload("res://Utils/StateManager.gd")
onready var States = {
	"IDLE": load("res://Player/States/Idle.gd").new(),
	"MOVE": load("res://Player/States/Move.gd").new(),
	"JUMP": load("res://Player/States/Jump.gd").new(),
	"HOOK": load("res://Player/States/FlyingToHook.gd").new(),
}
onready var StateManager = StateManagerReference.new(self, States, "IDLE")
onready var hook = $Hook
# Camera rotation
onready var camera = $Camera2D
var initialRotation = 0
var initialPosition = 0
var targetRotation = 0
var hook_target
# Player health
signal killed()
signal health_updated(health)
export (float) var maxHealth = 100
onready var health = maxHealth setget _set_health
onready var invulnerabilityTimer = $InvulnerabilityTimer
onready var effectsAnimation = $EffectsAnimation

# START
func _ready():
	pass

# UPDATES AT FIXED RATE
func _physics_process(delta):
	StateManager._handle_state(delta)
	
	# Rotate player while flying with hook
	if hook.hooked == true:
		rotate_player_while_flying()
	elif hook.hooked == false and hook.flying == false:
		rotation_degrees = targetRotation

# PLAYER HEALTH
func damage(amount):
	if invulnerabilityTimer.is_stopped():
		invulnerabilityTimer.start()
		_set_health(health - amount)

func kill():
	pass

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, maxHealth)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
			effectsAnimation.play("damage")

# HOOK-PLAYER LOGIC
func _on_hook_collision(_tip_position):
	StateManager.change_state({
		"state": States["HOOK"],
		"arguments": {
			"hook_target": _tip_position
		}
	})
	
	if hook.directionDegrees < 125 && hook.directionDegrees > 45: # DOWNWARDS
		targetRotation = 0
	elif hook.directionDegrees > -125 && hook.directionDegrees < -45: # UPWARDS
		targetRotation = 180
	elif ((hook.directionDegrees >= 125 && hook.directionDegrees <= 180) 
	or (hook.directionDegrees <= -125 && hook.directionDegrees >= -180)): # LEFT
		targetRotation = 90
	elif ((hook.directionDegrees <= 45 && hook.directionDegrees >= 0) 
	or (hook.directionDegrees >= -45 && hook.directionDegrees <= 0)): # RIGHT
		targetRotation = -90
	
	initialPosition = position
	initialRotation = rotation_degrees
	hook.initialDistance = position.distance_to(_tip_position)

func rotate_player_while_flying():
	if hook.currentDistance != null and hook.initialDistance != null:
		var t = hook.currentDistance / hook.initialDistance
		rotation_degrees = lerp(targetRotation, initialRotation, t)

func rotating_gravity():
	if gravityDirection == Vector2.UP or gravityDirection == Vector2.DOWN:
		velocity.y = velocity.y + gravity # Gravity Y axis ^v
	elif gravityDirection == Vector2.LEFT or gravityDirection == Vector2.RIGHT:
		velocity.x = velocity.x + gravity # Gravity X axis <>
	velocity = move_and_slide(velocity, gravityDirection)

func rotating_walk():
	if Input.is_action_pressed("right"): # If D or RIGHTARROW, go right
		if gravityDirection == Vector2.UP or gravityDirection == Vector2.DOWN:
			velocity.x = speed
		elif gravityDirection == Vector2.LEFT or gravityDirection == Vector2.RIGHT:
			velocity.y = -speed
	if Input.is_action_pressed("left"): # If A or LEFTARROW, go left
		if gravityDirection == Vector2.UP or gravityDirection == Vector2.DOWN:
			velocity.x = -speed
		elif gravityDirection == Vector2.LEFT or gravityDirection == Vector2.RIGHT:
			velocity.y = speed

func reverse_movement_variables():
	gravity = -gravity # Reversing gravity by making it negative
	jumpForce = -jumpForce # Reverse jumpforce
	speed = -speed # Reverse speed
	print("reversing: ", gravityDirection)
	

