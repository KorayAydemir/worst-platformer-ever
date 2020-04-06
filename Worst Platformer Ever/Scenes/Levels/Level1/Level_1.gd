extends Node2D

const ICE_SPEAR = preload("res://Scenes//Projectiles//IceSpear.tscn")
var rng_pos = RandomNumberGenerator.new()
var rng_rng = RandomNumberGenerator.new()
onready var player = (get_node("/root/Level_1/Player"))
func _ready():
	pass
	
	
func _random_spawn_pos():
	if player.area == "climb":
		var ice_spear = ICE_SPEAR.instance()
		add_child(ice_spear)
		
		rng_pos.randomize()
		rng_rng.randomize()
		var rng = rng_rng.randi_range( 0, 1) 
		ice_spear.position.y = $Player.position.y + 0
		ice_spear.position.x = $Player.position.x + 350
		print(player.area)
		
		
		#run straight ( spears from front and up )
		#y -100 to -350 # if y > -200: spear rotation = - 10  __ if y < -200 rot = 0
		#x 400 to 730
		
		#climb
		#
		
		
func _on_Timer_timeout():
	_random_spawn_pos()
	
	