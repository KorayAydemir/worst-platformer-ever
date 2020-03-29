extends "res://StateMachine.gd"

var distance_between = 500

var boss_pos 
var player_pos
func _ready():
	add_state("move")
	add_state("melee_attack")
	call_deferred("set_state", states.move)
	
func _state_logic(delta):
	parent._apply_movement()
func _physics_process(delta):
	boss_pos = parent.get_position()
	player_pos = get_node("/root/Level_1/Player").get_position()
	
func _get_transition(delta):
	print(state)
	match state:
		states.move: # in move state
			if player_pos.x - boss_pos.x < distance_between: # if player is too close to boss
				return states.melee_attack # switch to melee_attack state
				
		states.melee_attack: # in melee_attack state
			if player_pos.x - boss_pos.x > distance_between: # if player is far from boss
				return states.move
	return null
func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state, new_state):
	pass
	
	
#func _process(delta):
#	pass
