extends Area2D

export var spear_pickup = false
var main_scene = load("res://Scenes/MainFightScene.gd").new()
var player_status

func _ready():
	spear_pickup = false
	player_status = get_tree().get_root().get_node("Node2D/Player").status

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies:
		if not body.is_in_group("Player"): #or not body.is_in_group("Enemy"): # if the overlapping body is not the player, do not run any more code
			return
		#if(body.is_in_group("Player")):
		print("hit")
		#player_status = get_tree().get_root().get_node("Node2D/Player").status
		#player_status = 0
		print(main_scene)
		main_scene.destroy_spear()
		print(player_status)
		spear_pickup = true
		#get_parent().hide()
		#else:
		#	print("enemy hit")
		#	body.hide()
	set_physics_process(false)