extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)


func _input(event):
	# check if our current state is idle or run
	if [states.idle, states.run].has(state):
		# if jump is just pressed and char is grounded then jump
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump_velocity
		# drop through platform
		if Input.is_action_pressed("down"):
			if parent._check_is_grounded(parent.drop_thru_raycasts): #parent.drop_thru_raycasts on video
				parent.set_collision_mask_bit(parent.DROP_THRU_BIT, false)
				
	# check if our current state is jump
	if state == states.jump:
		# if jump key is released, fall
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity

func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()
	
func _get_transition(delta):
	match state:
		states.idle: # in idle satate
			if !parent.is_on_floor(): # if not on the ground
				if parent.is_jumping:  # if moving upwards
					return states.jump # switch to jump state
				elif parent.is_falling: # if moving downwards
					return states.fall # switch to fall state
			if parent.move_direction != 0: # if we are moving horizontally
				return states.run # switch to run state
		
		states.run: # in idle satate
			if !parent.is_on_floor(): # if not on the ground
				if parent.is_jumping:  # if moving upwards
					return states.jump # switch to jump state
				elif parent.is_falling: # if moving downwards
					return states.fall # switch to fall state
			if parent.move_direction == 0: # if we are not moving horizontally
				return states.idle # switch to idle state
				
		states.jump:
			if  parent.is_on_floor(): # if on the ground
				return states.idle	# switch to idle state
			elif parent.is_falling: # if moving downwards
				return states.fall # switch to fall state
				
		states.fall:
			if  parent.is_on_floor(): # if on the ground
				return states.idle	# switch to idle state
			elif parent.is_jumping: # if moving upwards
				return states.jump
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("Idle")
		states.run:
			parent.anim_player.play("Run")
		states.jump:
			parent.anim_player.play("Jump")
		states.fall:
			parent.anim_player.play("Fall")
	
func _exit_state(old_state, new_state):
	pass
	