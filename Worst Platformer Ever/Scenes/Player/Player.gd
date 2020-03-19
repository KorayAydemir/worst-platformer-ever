extends KinematicBody2D
#statem
signal grounded_updated(is_grounded)

const UP = Vector2(0, -1)
const DROP_THRU_BIT = 1

# horizontal movement
var velocity = Vector2()
var move_speed = 8 * Globals.UNIT_SIZE

# 
var is_grounded
var move_direction
var is_jumping
var is_falling
# jump
var gravity
var fall_gravity
var max_jump_velocity
var min_jump_velocity

var max_jump_height = 3.75 * Globals.UNIT_SIZE #3.5 yapıcaksın
var min_jump_height = 0.76 * Globals.UNIT_SIZE
var jump_duration = 0.4
var fall_duration = 0.35

onready var raycasts = $Raycasts
onready var anim_player = $Body/Sprite/AnimationPlayer

func _ready():
	# kinematic equations for determining gravity and jump velocity automatically
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	fall_gravity = 2 * max_jump_height / pow(fall_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt (2 * gravity * min_jump_height)

func _physics_process(delta):
	_get_input() # moving horizontally
	_assign_animation() # play animations
	if velocity.y >= 0:
		is_jumping = false
	else:
		is_jumping = true
		
	if velocity.y > 0:
		is_falling = true
	else:
		is_falling = false
	# apply jump gravity and fall gravity
	if is_jumping:
		velocity.y += gravity * delta 
	else:
		velocity.y += fall_gravity * delta
		
	velocity = move_and_slide(velocity, UP)
	is_grounded = !is_jumping  && get_collision_mask_bit(DROP_THRU_BIT) && _check_is_grounded()
	
	#camera stuff
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
	
func _input(event):
	# if jump is just pressed and char is grounded then jump
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = max_jump_velocity
	# if jump key is released, fall
	if event.is_action_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	# drop through platform
	if Input.is_action_pressed("down"):
		if _check_is_grounded($DropThruRaycasts):
			set_collision_mask_bit(DROP_THRU_BIT, false)
	
func _get_input(): # hold inputs
	 # horizontal movement direction
	move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	 # lerp(from, to, smoothness to apply)	
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	# flip the sprite
	if move_direction != 0:
		$Body.scale.x = move_direction
	
		
	# smoothness
func _get_h_weight():
	return 0.2 if is_grounded else 0.1
	
	
# check if raycasts are colliding with ground (is character on ground)
func _check_is_grounded(raycasts = self.raycasts):
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	# if loop completes then raycast was not detected
	return false
	
	
	# play animations
func _assign_animation():
	var anim = "Idle"
	if is_jumping:
		anim = "Jump"
	elif is_falling:
		anim = "Fall"
	elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		anim = "Run"
	if anim_player.assigned_animation != anim:
		anim_player.play(anim)

func _on_Area2D_body_exited(body):
	set_collision_mask_bit(DROP_THRU_BIT, true)