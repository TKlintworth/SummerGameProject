extends KinematicBody2D

var sec = 0.0
var timer
var waitTimer
var enabled = false
var kid
var kidPos
var kidVec = Vector2()
var move
var box
var shoot = false
var bLeft
var bRight
var bUp
var bDown
var spears = 3
var done = false
var test = false
var vel = Vector2()

func _ready():
	timer = Timer.new()
	timer.wait_time = 2
	add_child(timer)
	waitTimer = Timer.new()
	waitTimer.wait_time = 2
	add_child(waitTimer)
	kid = get_parent().get_child(1) #points to BoxKinematic
	move = get_parent().get_child(1) #points to BoxKinematic
	hide()
	box = get_tree().get_root().get_node("Node2D/BoxKinematic")

func _process(delta):
	if(Input.is_key_pressed(KEY_R) and shoot == false and spears >= 1):
		shoot = true
		if(test == false):
			spears -= 1
			test = true
		print("spear count: ", spears)
		timer.start()
		print(kid.get_position())
		kidPos = kid.get_position() # gets position of player
		show()
		
		# find the direction player is facing when "R" pressed
		if(box.left == true):
			bLeft = true
			self.position = kidPos + Vector2(-30, 0) # sets offset of spear
			set_rotation(deg2rad(180)) # rotates spear to face right direction
		elif(box.right == true):
			bRight = true
			self.position = kidPos + Vector2(30, 0)
			set_rotation(deg2rad(0))
		elif(box.down == true):
			bDown = true
			self.position = kidPos + Vector2(0, 30)
			set_rotation(deg2rad(90))
		elif(box.up == true):
			bUp = true
			self.position = kidPos + Vector2(0, -30)
			set_rotation(deg2rad(-90))
	if(timer.time_left > 0.2):
		_get_direction()
	if((timer.time_left <= 0.2) and enabled == true):
		bLeft = false
		bRight = false
		bUp = false
		bDown = false
		test = false
		hide()
		timer.stop()
		shoot = false
		#queue_free()
	vel = move_and_slide(vel)
		
func _get_direction():
	if(bLeft == true):
		vel.x = -300
		vel.y = 0
		enabled = true
	elif(bRight == true):
		vel.x = 300
		vel.y = 0
		enabled = true
	elif(bUp == true):
		vel.x = 0
		vel.y = -300
		enabled = true
	elif(bDown == true):
		vel.x = 0
		vel.y = 300
		enabled = true

func _on_Timer_timeout():
	sec += 1
