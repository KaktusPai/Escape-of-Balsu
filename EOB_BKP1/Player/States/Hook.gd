extends Node

var hook_target = null

func enter(host, _arguments):
	#print("hooking")
	if (!_arguments || !_arguments.has("hook_target")):
		return {
			"state": host.States["IDLE"]
		}
	hook_target = _arguments["hook_target"]
	execute(host)

func execute(host, _delta = 0.016666):
	var direction = -(host.global_position - hook_target).normalized()
	var collision = host.move_and_collide(direction * host.flyingWithHookSpeed)
	if collision:
		host.hook._release()
		
		# If hook destination is up or down, change gravity direction to match
		if host.hook.directionDegrees < 125 && host.hook.directionDegrees > 45: # DOWNWARDS
			print("Landed downwards ", host.gravityDirection, host.hook.directionDegrees)
			host.facingDirInt = 0
			if host.gravityDirection != Vector2.UP:
				if host.gravityDirection != Vector2.LEFT:
					host.reverse_movement_variables()
				host.gravityDirection = Vector2.UP # Set gravity up
				host.rotation_degrees = 0 # Player rotation 0 means facing up^
		
		elif host.hook.directionDegrees > -125 && host.hook.directionDegrees < -45: # UPWARDS
			print("Landed upwards ", host.gravityDirection, host.hook.directionDegrees) 
			host.facingDirInt = 1
			if host.gravityDirection != Vector2.DOWN :
				if host.gravityDirection != Vector2.RIGHT:
					host.reverse_movement_variables()
				host.gravityDirection = Vector2.DOWN
				host.rotation_degrees = 180
		
		# If hook destination is right or left, change gravity direction to match
		elif ((host.hook.directionDegrees >= 125 && host.hook.directionDegrees <= 180) 
		or (host.hook.directionDegrees <= -125 && host.hook.directionDegrees >= -180)): # LEFT
			print("Landed left ", host.gravityDirection, host.hook.directionDegrees) 
			host.facingDirInt = 2
			if host.gravityDirection != Vector2.RIGHT:
				if host.gravityDirection != Vector2.DOWN:
					host.reverse_movement_variables()
				host.gravityDirection = Vector2.RIGHT
				host.rotation_degrees = 90
		
		elif ((host.hook.directionDegrees <= 45 && host.hook.directionDegrees >= 0) 
		or (host.hook.directionDegrees >= -45 && host.hook.directionDegrees <= 0)): # RIGHT
			print("Landed right ", host.gravityDirection, host.hook.directionDegrees) 
			host.facingDirInt = 3
			if host.gravityDirection != Vector2.LEFT:
				if host.gravityDirection != Vector2.UP:
					host.reverse_movement_variables()
				host.gravityDirection = Vector2.LEFT
				host.rotation_degrees = -90
		print("gravity = ", host.gravity)
		# Camera rotation
		return {
			"state": host.States["IDLE"]
		}

func exit(_host):
	pass
	
