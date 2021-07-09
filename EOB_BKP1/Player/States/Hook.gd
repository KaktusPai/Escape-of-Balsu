extends Node

var hook_target = null

func enter(host, _arguments):
	print("hooking")
	if (!_arguments || !_arguments.has("hook_target")):
		return {
			"state": host.States["IDLE"]
		}
	hook_target = _arguments["hook_target"]
	execute(host)

func execute(host, _delta = 0.016666):
	var direction = -(host.global_position - hook_target).normalized()
	var collision = host.move_and_collide(direction * host.HOOK_FLY_SPEED)
	if collision:
		host.hook._release()
		# If hook destination is up or down, change gravity direction to match
		if host.hook.directionDegrees < 125 && host.hook.directionDegrees > 45: # DOWNWARDS
			print("Landed downwards ", host.gravityDirection, host.gravity)
			host.gravityDirection = Vector2.UP
			host.rotation_degrees = 180
			host.gravity = -host.gravity
			host.jumpForce = -host.jumpForce
			host.speed = -host.speed
		elif host.hook.directionDegrees > -125 && host.hook.directionDegrees < -45: # UPWARDS
			print("Landed upwards ", host.gravityDirection, host.gravity) 
			host.gravityDirection = Vector2.DOWN
			host.rotation_degrees = 0
			host.gravity = -host.gravity
			host.jumpForce = -host.jumpForce
			host.speed = -host.speed
		# If hook destination is right or left, change gravity direction to match
		elif host.hook.directionDegrees <= 125 && host.hook.directionDegrees >= -125: # LEFT
			print("Landed left ", host.gravityDirection, host.gravity) 
			host.gravityDirection = Vector2.RIGHT
			host.rotation_degrees = 180
			host.gravity = -host.gravity
			host.jumpForce = -host.jumpForce
			host.speed = -host.speed
		elif host.hook.directionDegrees <= 45 && host.hook.directionDegrees >= -45: # RIGHT
			print("Landed right ", host.gravityDirection, host.gravity) 
			host.gravityDirection = Vector2.LEFT
			host.rotation_degrees = 180
			host.gravity = -host.gravity
			host.jumpForce = -host.jumpForce
			host.speed = -host.speed
		
		# Camera rotation
		host.camera.rotation_degrees = host.rotation_degrees
		print(host.camera.rotation_degrees, " Degrees of hook rotation")
		return {
			"state": host.States["IDLE"]
		}

func exit(_host):
	pass
	
