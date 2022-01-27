extends Node

var hook_target = null

func enter(host, _arguments):
	print("flying to hook")
	if (!_arguments || !_arguments.has("hook_target")):
		return {
			"state": host.States["IDLE"]
		}
	hook_target = _arguments["hook_target"]
	execute(host)

func execute(host, _delta = 0.016666):
	var direction = -(host.global_position - hook_target).normalized()
	var collision = host.move_and_collide(direction * host.flyingWithHookSpeed)
	
	host.hook.currentDistance = host.position.distance_to(hook_target)
	
	if collision:
		host.hook._release()
		# TURNING GRAVITY only when (almost) at hook destination
		if host.hook.currentDistance <= 100:
			# If hook destination is up or down, change gravity and movement directions to match
			if host.hook.directionDegrees < 125 && host.hook.directionDegrees > 45: # DOWNWARDS
				print("Landed downwards ", host.gravityDirection, host.hook.directionDegrees)
				if host.gravityDirection != Vector2.UP:
					if host.gravityDirection != Vector2.LEFT:
						host.reverse_movement_variables()
					host.gravityDirection = Vector2.UP # Set gravity
			
			elif host.hook.directionDegrees > -125 && host.hook.directionDegrees < -45: # UPWARDS
				print("Landed upwards ", host.gravityDirection, host.hook.directionDegrees) 
				if host.gravityDirection != Vector2.DOWN :
					if host.gravityDirection != Vector2.RIGHT:
						host.reverse_movement_variables()
					host.gravityDirection = Vector2.DOWN
			
			# If hook destination is right or left, change gravity direction to match
			elif ((host.hook.directionDegrees >= 125 && host.hook.directionDegrees <= 180) 
			or (host.hook.directionDegrees <= -125 && host.hook.directionDegrees >= -180)): # LEFT
				print("Landed left ", host.gravityDirection, host.hook.directionDegrees) 
				if host.gravityDirection != Vector2.RIGHT:
					if host.gravityDirection != Vector2.DOWN:
						host.reverse_movement_variables()
					host.gravityDirection = Vector2.RIGHT
			
			elif ((host.hook.directionDegrees <= 45 && host.hook.directionDegrees >= 0) 
			or (host.hook.directionDegrees >= -45 && host.hook.directionDegrees <= 0)): # RIGHT
				print("Landed right ", host.gravityDirection, host.hook.directionDegrees) 
				if host.gravityDirection != Vector2.LEFT:
					if host.gravityDirection != Vector2.UP:
						host.reverse_movement_variables()
					host.gravityDirection = Vector2.LEFT
					
		print("gravity = ", host.gravity)
		return {
					"state": host.States["IDLE"]
				}

func exit(_host):
	pass
	
