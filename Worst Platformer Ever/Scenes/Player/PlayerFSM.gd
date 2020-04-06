extends "res://StateMachine.gd"
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("ledge_fall")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)

func _input(event):
	# check if our current state is idle or run
	if [states.idle, states.run].has(state) || !parent.coyote_timer.is_stopped() || parent.spear_jump:
		# if jump is just pressed and char is grounded then jump
		if event.is_action_pressed("jump"):
				parent.velocity.y = parent.max_jump_velocity
				parent.coyote_timer.stop()
				parent.spear_jump = false
		# drop through platform
		if Input.is_action_pressed("down"):
			if parent._check_is_grounded(parent.drop_thru_raycasts): #parent.drop_thru_raycasts on video
				parent.set_collision_mask_bit(parent.DROP_THRU_BIT, false) # stop colliding with drop_thru layer
	
	elif state ==  states.wall_slide:
		if event.is_action_pressed("jump"):
			parent.wall_jump()
			set_state(states.jump)
	# check if our current state is jump
	if state == states.jump:
		# if jump key is released, fall
		if event.is_action_released("jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity
			
func _state_logic(delta):
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall_slide:
		parent._handle_move_input()
	parent._apply_gravity(delta)
	if state == states.wall_slide:
		parent._cap_gravity_wall_slide()
		parent._handle_wall_slide_sticking()
	parent._apply_movement()
	
func _get_transition(delta):
#	print(state)
	match state:
		states.idle: # in idle satate
			if !parent.is_on_floor(): # if not on the ground
				if parent.is_jumping:  # if moving upwards
					return states.jump # switch to jump state
				elif parent.is_falling: # if moving downwards
					return states.ledge_fall # switch to fall state
			if parent.move_direction != 0: # if we are moving horizontally
				return states.run # switch to run state
#Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")
		states.run: # in run satate
			if !parent.is_on_floor(): # if not on the ground
				if parent.is_jumping:  # if moving upwards
					return states.jump # switch to jump state
				elif parent.is_falling: # if moving downwards
					return states.ledge_fall # switch to fall state
			if parent.move_direction == 0: # if we are not moving horizontally parent.move_direction == 0
				return states.idle # switch to idle state
#Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right")
		states.jump:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif  parent.is_on_floor(): # if on the ground
				return states.idle	# switch to idle state
			elif parent.is_falling: # if moving downwards
				return states.fall # switch to fall state
				
		states.fall:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			if  parent.is_on_floor(): # if on the ground
				return states.idle	# switch to idle state
			elif parent.is_jumping: # if moving upwards
				return states.jump
		states.ledge_fall:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			if  parent.is_on_floor(): # if on the ground
				return states.idle	# switch to idle state
			elif parent.is_jumping: # if moving upwards
				return states.jump
		states.wall_slide:
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("Idle")
		states.run:
			parent.anim_player.play("Run")
		states.jump:
			parent.anim_player.play("Jump")
			parent.coyote_timer.stop()
		states.fall:
			parent.anim_player.play("Fall")
		states.ledge_fall:
			parent.coyote_timer.start()
			parent.anim_player.play("Fall")
		states.wall_slide:
			parent.anim_player.play("Jump")
			parent.body.scale.x = -parent.wall_direction
			
func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_slide_cooldown.start()

func _on_WallSlideSticky_timeout():
	if state == states.wall_slide:
		set_state(states.fall)