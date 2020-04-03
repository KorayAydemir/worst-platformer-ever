extends KinematicBody2D

var velocity = Vector2()
var t = true
var move_speed = 15 * Globals.UNIT_SIZE

onready var player = (get_node("/root/Level_1/Player"))


func _ready():
	pass
	
func _physics_process(delta):
	_rotate_timer()
	if t == true:
		self.look_at(player.position)
		self.rotation_degrees = self.rotation_degrees - 10
	else:
		_apply_movement() # move after rotation is completed
		


func _apply_movement():
	velocity = move_and_slide(velocity, Vector2(0,1))
	velocity = Vector2(move_speed,0).rotated(rotation)
	#move_speed = -1 * Globals.UNIT_SIZE
	#yield(get_tree().create_timer(0.5), "timeout")
	
func _rotate_timer():
	yield(get_tree().create_timer(1.5), "timeout")
	t = false
	


