extends KinematicBody2D

# Movement variables
export var velocity = Vector2(0,0)
export var slowDownWeight = 0.2
export var gravityDirection = Vector2.UP
export var gravity = 40
export var velocityAxisX = 0
export var velocityAxisY = 0
var standardAxis = false

const StateManagerReference = preload("res://Utils/StateManager.gd")

export var speed = 600
const HOOK_FLY_SPEED = 30
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

