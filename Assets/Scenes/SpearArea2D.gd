extends Area2D


func _ready():
	pass

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies:
			return
	for body in overlapping_bodies:
		if not body.is_in_group("Player"):
			return
		#body.take_damage()
		print("hit")
		body.hide()
	set_physics_process(false)