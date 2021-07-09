extends Node

func enter(host, _arguments):
	print("jumping")
	host.velocity.y = host.velocity.y + host.gravity # Gravity
	host.velocity = host.move_and_slide(host.velocity, host.gravityDirection)
	execute(host)

func execute(host, _delta = 0.016666):
	if host.is_on_floor():
		return {
			"state": host.States["IDLE"]
		}
	
	if Input.is_action_pressed("right"): # If D or RIGHTARROW, go right
		host.velocity.x = host.speed

	if Input.is_action_pressed("left"): # If A or LEFTARROW, go left
		host.velocity.x = -host.speed
		
	# Shooting and releasing hook
	if Input.is_action_just_pressed("fire_hook"):
		var mouse_position = host.get_global_mouse_position()
		host.hook._shoot(-(host.global_position - mouse_position))
	if Input.is_action_just_released("fire_hook"):
		host.hook._release()
	
	# Gravity
	host.velocity.y = host.velocity.y + host.gravity # Gravity
	host.velocity = host.move_and_slide(host.velocity, host.gravityDirection)

func exit(_host):
	pass
