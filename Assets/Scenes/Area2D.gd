extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	self.hide()

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	var spear_attack_enabled = get_parent().spear_attack_bool
	
	if(spear_attack_enabled == true):
		if not overlapping_bodies:
			return
		for body in overlapping_bodies:
			if not body.is_in_group("Character"):
				return
			#body.take_damage()
			print("hit")
			body.hide()
		set_physics_process(false)
		
func take_damage():
	pass