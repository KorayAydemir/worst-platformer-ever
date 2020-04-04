extends Node2D

const ICE_SPEAR = preload("res://Scenes//Projectiles//IceSpear.tscn")
var rng_pos = RandomNumberGenerator.new()

func _ready():
	pass
	
	
func _random_spawn_pos():
	var ice_spear = ICE_SPEAR.instance()
	add_child(ice_spear)
	
	rng_pos.randomize()
	ice_spear.position.y = $Player.position.y - rng_pos.randf_range(200, 320)
	ice_spear.position.x = $Player.position.x + rng_pos.randf_range(-230, 850)

func _on_Timer_timeout():
	_random_spawn_pos()