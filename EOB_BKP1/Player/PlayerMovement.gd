extends KinematicBody2D

# Movement variables
export var velocity = Vector2(0,0)
export var slowDownWeight = 0.2
export var gravityDirection = Vector2.UP
export var facingDirInt = 0 # 0 = DOWN 1 = UP 2 = LEFT 3 = RIGHT
export var gravity = 40

const StateManagerReference = preload("res://Utils/StateManager.gd")

export var speed = 600
export var flyingWithHookSpeed = 30
export var jumpForce = -1100

onready var States = {
	"IDLE": load("res://Player/States/Idle.gd").new(),
	"MOVE": load("res://Player/States/Move.gd").new(),
	"JUMP": load("res://Player/States/Jump.gd").new(),
	"HOOK": load("res://Player/States/Hook.gd").new(),
}
onready var StateManager = StateManagerReference.new(self, States, "IDLE")
onready var hook = $Hook
onready var camera = $Camera2D

var hook_target

func _ready():
	pass

# Essentially like Update() in Unity, updates 60fps
func _physics_process(delta):
	StateManager._handle_state(delta)

func _on_hook_collision(_tip_position):
	StateManager.change_state({
		"state": States["HOOK"],
		"arguments": {
			"hook_target": _tip_position
		}
	})

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
