extends Node2D

signal hook_collision

const HOOK_SPEED = 50

onready var tip = $Tip

var direction
var directionDegrees
var hookPosition = Vector2(0, 0)
var flying = false
var hooked = false

func _shoot(dir):
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	directionDegrees = rad2deg(direction.angle())
	tip.rotation_degrees = directionDegrees # Rotate the tip
	print(directionDegrees, " Tip points to this angle")

# release() the chain
func _release():
	flying = false	# Not flying anymore
	hooked = false	# Not attached anymore
	tip.position = Vector2(0, 0)

func _physics_process(_delta):
	if flying:
		var has_collided = tip.move_and_collide(direction * HOOK_SPEED)
		if has_collided:
			hooked = true	# Got something!
			flying = false	# Not flying anymore
			hookPosition = tip.global_position
			emit_signal("hook_collision", tip.global_position)
		#print(HOOK_SPEED)
	elif hooked:
		tip.global_position = hookPosition

