extends Node2D

signal hook_collision

const SPEED = 50

onready var tip = $Tip

var direction
var hook_position = Vector2(0, 0)
var flying = false
var hooked = false

func _shoot(dir):
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip.look_at(get_global_mouse_position())

# release() the chain
func _release():
	flying = false	# Not flying anymore
	hooked = false	# Not attached anymore
	tip.position = Vector2(0, 0)

func _physics_process(_delta):
	if flying:
		var has_collided = tip.move_and_collide(direction * SPEED)
		if has_collided:
			hooked = true	# Got something!
			flying = false	# Not flying anymore
			hook_position = tip.global_position
			emit_signal("hook_collision", tip.global_position)
	elif hooked:
		tip.global_position = hook_position

