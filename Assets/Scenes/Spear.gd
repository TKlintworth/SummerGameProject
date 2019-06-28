extends KinematicBody2D

var vel = Vector2()
var sec = 0.0
var timer
var timer_done = false
var timer_start = false

func _ready():
	timer = Timer.new()
	timer.wait_time = 1.5
	add_child(timer)
	self.hide()

func get_input():
	if Input.is_action_pressed("T"):
		timer.start()
		timer_start = true
		print(timer.time_left)
		#self.show()
		#self.add_force(Vector2(0,0), Vector2(-200,0))
		vel.x = -300
		vel.y = 0

func _process(delta):
	#vel = move_and_slide(vel)
	print(timer.time_left)
	if(timer.time_left <= 0.5 && timer_start == true):
		self.show()
		timer_done = true
	if(timer_done == true):
		vel = move_and_slide(vel)
	print(sec)
	get_input()
	


func _on_Timer_timeout():
	sec += 1
