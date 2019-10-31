extends Area2D

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies:
		if not body.is_in_group("Player"):
			return
		get_parent().get_tree().get_root().get_node("MainRoot/Player").increase_health(25)
		get_parent().get_tree().get_root().get_node("MainRoot").remove_health_from_array()
		self.queue_free() 
