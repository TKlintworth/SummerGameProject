extends KinematicBody2D

var vel = Vector2()

var left = false
var right = false
var up = false
var down = false

var man_spear = preload("res://manSpear.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _input(event):
#	if(event.is_action_pressed("leftKey")):
#		self.move_local_x(-2)
#	if(event.is_action_pressed("rightKey")):
#		self.move_local_x(2)
#	if(event.is_action_pressed("upKey")):
#		self.move_local_y(-2)
#	if(event.is_action_pressed("downKey")):
#		self.move_local_y(-2)

func _process(delta): #need to change to _onEvent
	if(Input.is_key_pressed(KEY_LEFT)):
		$Sprite.set_flip_h(false)
		vel.x = -300
		left = true
		right = false
		down = false
		up = false
	elif(Input.is_key_pressed(KEY_RIGHT)):
		$Sprite.set_flip_h(true)
		vel.x = 300
		left = false
		right = true
		down = false
		up = false
	elif(Input.is_key_pressed(KEY_DOWN)):
		$Sprite.set_texture(man_spear)
		vel.y = 300
		left = false
		right = false
		down = true
		up = false
	elif(Input.is_key_pressed(KEY_UP)):
		vel.y = -300
		left = false
		right = false
		down = false
		up = true
	else:
		vel.x = 0
		vel.y = 0
	
	vel = move_and_slide(vel)
	