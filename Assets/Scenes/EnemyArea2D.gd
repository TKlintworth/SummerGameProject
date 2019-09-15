extends Area2D

func _ready():
	pass

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies: 
	# may want to find better way to do this
		if body.is_in_group("Spear"): # enemy hit by spear
			get_parent().hit = true # destroy spear and enemy
		
		
		
		
func _on_AnimatedSprite_animation_finished():
	get_parent().attack = false # enemy will stop playing attack animation


 # Replace with function body.
