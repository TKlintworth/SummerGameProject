extends KinematicBody2D

var speed = 150

func _ready():
	pass


func _fixed_process(delta):
	var body = get_node("body").get_overlapping_bodies()
	var Move = Vector2()
	
	if(body.size() != 0):
		for tinge in body:
			if(tinge.is_in_group("player")):
				if(tinge.get_global_position().x < self.get_global_position().x):
					Move += Vector2(-1, 0)
	Move = Move.normalized() * speed * delta
	Move = move(Move)
