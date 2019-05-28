extends KinematicBody2D

var vel = Vector2()

func _ready():
	pass # Replace with function body.

func _process(delta):
	if(Input.is_key_pressed(KEY_LEFT)):
		vel.x = -300
	elif(Input.is_key_pressed(KEY_RIGHT)):
		vel.x = 300
	elif(Input.is_key_pressed(KEY_DOWN)):
		vel.y = 300
	elif(Input.is_key_pressed(KEY_UP)):
		vel.y = -300
	else:
		vel.x = 0
		vel.y = 0
	
	vel = move_and_slide(vel)