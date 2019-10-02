extends Area2D

var face_left = Vector2(-105.5, -14)
var face_right = Vector2(105.5, -14)

func _ready():
	pass

func check_if_enemy_hit():
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	if overlapping_bodies.size() >= 2:
		print(overlapping_bodies[1].get_parent().name)
		#overlapping_bodies[0].queue.free()
	#for body in overlapping_bodies: 
	#	print(overlapping_bodies.size())
	#	print("name")
	#	print(body.name)
	#	if not body.is_in_group("Enemy1"):
	#		return
		#body.queue_free()
		print("hit")
		#get_parent().get_parent().destroy_enemy()

func _process(delta):
	#check_if_enemy_hit()
	match get_parent().character_direction:
		0: $SpearCollisionShape.position = face_left # player facing left, move collider to left
		1: $SpearCollisionShape.position = face_right # player facing right, move collider to right
	
	#if jab_attack == true:
	#	check_if_enemy_hit()
