extends Node

var host
var states = {}
var default_state

var stack = []
var stack_size = 10

func _init(_host, _states, _default_state, arguments = null):
	host = _host
	states = _states
	default_state = _default_state
	var state_data = {
		"state": states[default_state]
	}
	if arguments:
		state_data["arguments"] = arguments
	change_state(state_data)
	
func _handle_state(delta):
	var current_state = current_state()
	var update_state_data = current_state.execute(host, delta)
	if update_state_data != null:
		change_state(update_state_data)

func current_state(): return stack[len(stack) - 1]
	
func change_state(new_state_data):
	var previous_state
	var arguments
	if new_state_data.has("arguments"):
		arguments = new_state_data["arguments"]
	if len(stack) > 0:
		previous_state = current_state()
	
	stack.append(new_state_data["state"])
	var current_state = current_state()
	if len(stack) > stack_size:
		stack.remove(0)
	
	if previous_state != null:
		previous_state.exit(host)
	if current_state != null:
		current_state.enter(host, arguments)
