extends Node

func enter(host, _arguments):
	print("moving")
	execute(host)

func execute(host, _delta = 0.016666):
	if Input.is_action_just_pressed("jump") && host.is_on_floor():
		return {
			"state": host.States["JUMP"]
		}
	if ![Input.is_action_pressed("right"), Input.is_action_pressed("left")].has(true):
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
