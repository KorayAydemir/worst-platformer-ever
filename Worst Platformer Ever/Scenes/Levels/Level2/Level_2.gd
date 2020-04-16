extends Node2D
const PLAYER = preload("res://Scenes//Player//Player.tscn")
func _ready():
	var my_player = PLAYER.instance()
	add_child(my_player)