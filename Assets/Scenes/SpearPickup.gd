extends Area2D

export var spear_pickup = false
#var main_scene = load("res://Scenes/MainFightScene.gd").new()
var player_status
var spear_gone = false # tells if spear has hit enemy or not

func _ready():
	spear_pickup = false
	player_status = get_tree().get_root().get_node("MainRoot/Player").player_status

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
		self.queue_free()
		
	set_physics_process(false)