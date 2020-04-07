extends KinematicBody2D

var velocity = Vector2()
var t = true
var spear_speed = 15
var move_speed = spear_speed * Globals.UNIT_SIZE

onready var player = (get_node("/root/Level_1/Player"))
onready var particles = (get_node("Particles2D"))
onready var level1 = (get_node("/root/Level_1"))

func _ready():
	pass
func _physics_process(delta):
	
	if t == true:
		self.look_at(player.position)
		particles.look_at(player.position)
		if player.area == "climb": #while climbin
			if level1.spear_direction == "front": # spears coming form front - up and down
				self.rotation_degrees = self.rotation_degrees + 22 # make rot + 20
			else: # spears coming from behind - up and down rot -20
				self.rotation_degrees = self.rotation_degrees + -22 # make rot -20
				# print("climb")
		elif player.area == "slide": # while slidin
			if level1.spear_direction == "front": # spears coming from front - down
				self.rotation_degrees = self.rotation_degrees + -20
			else: #spears coming from behind - down
				self.rotation_degrees = self.rotation_degrees + 20
				# print("slide")
		elif player.area == "run": # while runnin-jumpin straight:
			if level1.spear_direction == "front": # spears coming form front - up and down
				self.rotation_degrees = self.rotation_degrees + -20 # make rot + 20
			else: # spears coming from behind - up and down rot -20
				self.rotation_degrees = self.rotation_degrees + -15 # make rot -20
		
	else: # - 17  else + 17 rot for sliding down
		_apply_movement() # move after rotation is completed
		


func _apply_movement():
	velocity = move_and_slide(velocity, Vector2(0,1))
	velocity = Vector2(move_speed,0).rotated(rotation)
	
	
func _rotate_timer():
	
	t = false
	

func _on_Timer_timeout():
	_rotate_timer()
	