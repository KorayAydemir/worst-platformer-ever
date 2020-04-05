extends KinematicBody2D
#statem
signal grounded_updated(is_grounded)

const UP = Vector2(0, -1)
const DROP_THRU_BIT = 1

# horizontal movement
var velocity = Vector2()
var move_speed = 8 * Globals.UNIT_SIZE
const WALL_JUMP_VELOCITY = Vector2(300, -700) # x= how far you jump from wall y = how high you climb (Jump) on wall
# 
var is_grounded
var move_direction
var is_jumping
var is_falling
var spear_jump
# jump
var gravity
var fall_gravity
var max_jump_velocity
var min_jump_velocity

var max_jump_height = 4.25 * Globals.UNIT_SIZE 
var min_jump_height = 1.25 * Globals.UNIT_SIZE
var jump_duration = 0.35
var fall_duration = 0.4
var air_control = 1
var facing = 1 #not in use
var wall_direction = 1

onready var drop_thru_raycasts = $DropThruRaycasts
onready var raycasts = $Raycasts
onready var anim_player = $Body/Sprite/AnimationPlayer
onready var coyote_timer = $CoyoteTimer
onready var body = $Body
onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts
onready var wall_slide_cooldown = $WallSlideCooldown
onready var wall_slide_sticky_timer = $WallSlideSticky

func _ready():
	# kinematic equations for determining gravity and jump velocity automatically
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	fall_gravity = 2 * max_jump_height / pow(fall_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt (2 * gravity * min_jump_height)
	#Engine.time_scale = 0.5

	
func _apply_gravity(delta): # jump
	if is_jumping:
		velocity.y += gravity * delta 
	else: # fall gravity
		velocity.y += fall_gravity * delta
func wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity

func _cap_gravity_wall_slide():
	var max_velocity = 3 * Globals.UNIT_SIZE if !Input.is_action_pressed("down") else 10 * Globals.UNIT_SIZE
	velocity.y = min(velocity.y, max_velocity)
		
func _apply_movement():
	if velocity.y >= 0:
		is_jumping = false    
	else:
		is_jumping = true
	if velocity.y > 0:
		is_falling = true
	else:
		is_falling = false
	
	# coyote jump
	var was_on_floor = is_on_floor()
		
	velocity = move_and_slide(velocity, UP, 10) # horizontal movement
	
	is_grounded = !is_jumping  && get_collision_mask_bit(DROP_THRU_BIT) && _check_is_grounded()
	
	#camera stuff
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
		
	
func _update_move_direction():
	 # horizontal movement direction
	move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	
func _handle_move_input(): # hold inputs
	 # lerp(from, to, smoothness to apply)	
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	# flip the sprite
	if move_direction != 0:
		$Body.scale.x = move_direction
	
		
func _handle_wall_slide_sticking():
	if move_direction != 0 && move_direction != wall_direction:
		if wall_slide_sticky_timer.is_stopped():
			wall_slide_sticky_timer.start()
	else:
		wall_slide_sticky_timer.stop()
		
	# smoothness
func _get_h_weight():
	#return 0.2 if is_grounded else air_control
	if is_grounded:
		return 0.2
	else:
		if move_direction == 0:
			return 0.1
		elif move_direction == sign(velocity.x) && abs(velocity.x) > move_speed:
			return 15 # the fall after leaving wall slide
		else:
			return 0.1 #superpower if u make it 12 # walljump air control 
	
# check if raycasts are colliding with ground (is character on ground)
func _check_is_grounded(raycasts = self.raycasts):
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	# if loop completes then raycast was not detected
	return false
	
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	if is_near_wall_left && is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 && dot < PI * 0.55:
				return true
	return false

	


func _on_Area2D_body_exited(body):
	set_collision_mask_bit(DROP_THRU_BIT, true)



func _on_SceneChangeArea_body_entered(body):
	SceneChanger.change_scene("res://Scenes/Levels/Level1/Level_1.tscn")





	

func _on_DeathArea_area_entered(area):
	Engine.time_scale = 0.0
	
	get_tree().change_scene("res://Scenes/Levels/Level1/Level_1.tscn")
	print("death area")

func _on_DeathArea_area_exited(area):
	
	Engine.time_scale = 1

func _on_SpearJump_area_entered(area):
	spear_jump = true
	print("spear jump area")
	#move_speed *= 2

func _on_SpearJump_area_exited(area):
	spear_jump = false
	
	

func _on_SlowMoArea_area_entered(area):
	Engine.time_scale = 0.4
	print("slowmo area")

func _on_SlowMoArea_area_exited(area):
	Engine.time_scale = 1