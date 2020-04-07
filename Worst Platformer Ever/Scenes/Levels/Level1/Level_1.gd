extends Node2D

const ICE_SPEAR = preload("res://Scenes//Projectiles//IceSpear.tscn")
var rng_pos = RandomNumberGenerator.new()
var rng_rng = RandomNumberGenerator.new()
onready var player = (get_node("/root/Level_1/Player"))
var spear_direction

func _ready():
	pass
	
	
func _random_spawn_pos():
	if player.area == "climb":
		var ice_spear = ICE_SPEAR.instance()
		add_child(ice_spear)
		
		rng_pos.randomize()
		rng_rng.randomize()
		var rng = rng_rng.randi_range( 0, 1)
		if rng == 1:
			#climb - spears coming form front - up and down rot 20 
			spear_direction = "front"			
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -250, 175) # -250 to 175
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( 250, 380) # 250 to 380 
		elif rng == 0:
			rng_pos.randomize()
			spear_direction = "behind"
			#climb - spears coming from behind - up and down rot -20
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -250, 175) #y + = -250 to 175
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( -380 ,-250 ) #x + = -250 to -380
			#print(player.area)
			
	elif player.area == "slide":
		var ice_spear = ICE_SPEAR.instance()
		add_child(ice_spear)
		
		rng_pos.randomize()
		rng_rng.randomize()
		var rng = rng_rng.randi_range( 0, 1)
		if rng == 1:
			#climb - spears coming form front - up and down rot 20 
			spear_direction = "front"
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -250, 175) # -250 to 175
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( 250, 380) # 250 to 380 
		elif rng == 0:
			rng_pos.randomize()
			spear_direction = "behind"
			#climb - spears coming from behind - up and down rot -20
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -250, 175) #y + = -250 to 175
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( -380 ,-250 ) #x + = -250 to -380
			#print(player.area)
	
	if player.area == "run":
		var ice_spear = ICE_SPEAR.instance()
		add_child(ice_spear)
		
		rng_pos.randomize()
		rng_rng.randomize()
		var rng = rng_rng.randi_range( 0, 1)
		if rng == 1:
			#climb - spears coming form front - up and down rot 20 
			spear_direction = "front"
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -350, -175) # only from up
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( 350, 700) # 250 to 380 
		elif rng == 0:
			rng_pos.randomize()
			spear_direction = "behind" # TODO fix behind-up coming spears
			#climb - spears coming from behind - up 
			ice_spear.position.y = $Player.position.y + rng_pos.randi_range( -375, -100) #y + = -250 to 175
			ice_spear.position.x = $Player.position.x + rng_pos.randi_range( -380 ,-250 ) #x + = -250 to -380
			#print(player.area)
		
		#run straight ( spears from front and up )
		#y -100 to -350 # if y > -200: spear rotation = - 10  __ if y < -200 rot = 0
		#x 400 to 730
		
		
		
func _on_Timer_timeout():
	_random_spawn_pos()
	
	