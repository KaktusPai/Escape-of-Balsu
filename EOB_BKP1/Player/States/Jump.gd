extends Node

func enter(host, _arguments):
	#print("jumping")
	if host.gravityDirection == Vector2.UP or host.gravityDirection == Vector2.DOWN:
		host.velocity.y = host.jumpForce
		host.velocity.y = host.velocity.y + host.gravity # Gravity
	elif host.gravityDirection == Vector2.LEFT or host.gravityDirection == Vector2.RIGHT:
		host.velocity.x = host.jumpForce
		host.velocity.x = host.velocity.x + host.gravity # Gravity
	
	host.velocity = host.move_and_slide(host.velocity, host.gravityDirection)
	execute(host)

func execute(host, _delta = 0.016666):
	if host.is_on_floor():
		return {
			"state": host.States["IDLE"]
		}
	
	# Move while jumping
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
