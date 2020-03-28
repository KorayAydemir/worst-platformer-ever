extends "res://StateMachine.gd"

func _ready():
	add_state("move")



func _state_logic(delta):
	pass
	
func _get_transition(delta):
	return null
	
func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state, new_state):
	pass
	
	
#func _process(delta):
#	pass
