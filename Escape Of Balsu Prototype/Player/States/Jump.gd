extends Node

func enter(host, _arguments):
	print("jumping")
	host.velocity.y = host.JUMPFORCE
	host.velocity.y = host.velocity.y + host.GRAVITY # Gravity
	host.velocity = host.move_and_slide(host.velocity, host.gravityDirection)
	execute(host)

func execute(host, _delta = 0.016666):
	if host.is_on_floor():
		return {
			"state": host.States["IDLE"]
		}
	
	if Input.is_action_pressed("right"): # If D or RIGHTARROW, go right
		host.velocity.x = host.SPEED
	if Input.is_action_pressed("left"): # If A or LEFTARROW, go left
		host.velocity.x = -host.SPEED
	
	host.velocity.y = host.velocity.y + host.GRAVITY # Gravity
	host.velocity = host.move_and_slide(host.velocity, host.gravityDirection)

func exit(_host):
	pass
