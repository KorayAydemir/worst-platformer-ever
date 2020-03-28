extends KinematicBody2D

onready var player = (get_node("/root/Level_1/Player"))
func _ready():
	pass
func _process(delta):
	$eyeball.look_at(player.get_position())
	
	
