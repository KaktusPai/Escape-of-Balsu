extends Node

var hook_target = null
var rotation_degree = 0

func enter(host, _arguments):
	print("hooking")
	if (!_arguments || !_arguments.has("hook_target")):
		return {
			"state": host.States["IDLE"]
		}
	hook_target = _arguments["hook_target"]
	host.tip.
	execute(host)

func execute(host, _delta = 0.016666):
	var direction = -(host.global_position - hook_target).normalized()
	var collision = host.move_and_collide(direction * host.HOOK_SPEED)
	if collision:
		host.hook._release()
		return {
			"state": host.States["IDLE"]
		}

func exit(_host):
	
	!_host.gravityDirection 
