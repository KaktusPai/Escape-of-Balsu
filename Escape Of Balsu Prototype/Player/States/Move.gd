extends Node

func enter(host, _arguments):
	#print("moving")
	execute(host)

func execute(host, _delta = 0.016666):
	if (Input.is_action_just_pressed("jump") && 
		host.is_on_floor() or host.is_on_ceiling()):
		return {
			"state": host.States["JUMP"]
		}
	if ![Input.is_action_pressed("right"), Input.is_action_pressed("left")].has(true):
		return {
			"state": host.States["IDLE"]
		}
	# Moving left and right
	host.rotating_walk()
		
	# Shooting and releasing hook
	if Input.is_action_just_pressed("fire_hook"):
		var mouse_position = host.get_global_mouse_position()
		host.hook._shoot(-(host.global_position - mouse_position))
	if Input.is_action_just_released("fire_hook"):
		host.hook._release()
		
	# Gravity
	host.rotating_gravity()

func exit(_host):
	pass
