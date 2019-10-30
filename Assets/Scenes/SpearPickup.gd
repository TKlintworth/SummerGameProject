extends Area2D
	
func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies:
		if not body.is_in_group("Player"):
			return
		print("player entered area")
		get_parent().get_tree().get_root().get_node("MainRoot/Player").set_player_status(0)
		get_parent().get_tree().get_root().get_node("MainRoot/Player").set_thrown(false)
		get_parent().get_tree().get_root().get_node("MainRoot").remove_spear_from_array()
		self.queue_free() 