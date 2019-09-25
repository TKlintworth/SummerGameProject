extends Area2D

var face_left = Vector2(-105.5, -14)
var face_right = Vector2(105.5, -14)

func _ready():
	print(self.get_groups())

func check_if_enemy_hit():
	var overlapping_bodies = get_overlapping_bodies()

	if not overlapping_bodies: # if no overlapping bodies, do not run any more code
			return
	for body in overlapping_bodies: 
		
		if not body.is_in_group("Enemy1"):
			return
		print("hit")
		#get_parent().get_parent().destroy_enemy()

func _process(delta):
	print("layers")
	print(self.collision_layer)
	print("mask")
	print(self.collision_mask)
	match get_parent().character_direction:
		0: $SpearCollisionShape.position = face_left # player facing left, move collider to left
		1: $SpearCollisionShape.position = face_right # player facing right, move collider to right
	
	#if jab_attack == true:
	#	check_if_enemy_hit()
