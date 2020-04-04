extends KinematicBody2D

var velocity = Vector2()
var t = true
var spear_speed = 15
var move_speed = spear_speed * Globals.UNIT_SIZE

onready var player = (get_node("/root/Level_1/Player"))


func _ready():
	pass
	
func _physics_process(delta):
	
	if t == true:
		self.look_at(player.position)
		self.rotation_degrees = self.rotation_degrees - 10
	else:
		_apply_movement() # move after rotation is completed
		


func _apply_movement():
	velocity = move_and_slide(velocity, Vector2(0,1))
	velocity = Vector2(move_speed,0).rotated(rotation)
	
	
func _rotate_timer():
	
	t = false
	

func _on_Timer_timeout():
	_rotate_timer()
	print("rot")