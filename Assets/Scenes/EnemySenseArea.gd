extends Area2D


func _ready():
	pass

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies: 
		if not body.is_in_group("Player"):
			return
		get_parent().attack = true # enemy will perform attack animation
	
