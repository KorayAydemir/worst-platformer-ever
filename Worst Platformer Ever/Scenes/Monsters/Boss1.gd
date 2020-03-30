extends KinematicBody2D

var velocity = Vector2()

onready var player = (get_node("/root/Level_1/Player"))
func _ready():
	pass
func _process(delta):
	$eyeball.look_at(player.get_position())
	
func _apply_movement():
	velocity = move_and_slide(velocity, Vector2(0,1))
	velocity.x = lerp(velocity.x, 2 * Globals.UNIT_SIZE, 0.2)