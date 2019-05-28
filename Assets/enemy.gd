extends KinematicBody2D

onready var Player = get_parent().get_node("BoxKinematic")

var react_time = 400
var dir = 0
var dir_y = 0
var next_dir = 0
var next_dir_y = 0
var next_dir_time = 0
var next_dir_time_y = 0
var vel = Vector2(0,0)

func _ready():
	set_process(true)


func _process(delta):
	
	if(Player.position.x < self.position.x and next_dir != -1):
		next_dir = -1
		next_dir_time = OS.get_ticks_msec() + react_time
		#self.move_local_x(-2)
	elif(Player.position.x > self.position.x and next_dir != 1):
		next_dir = 1
		next_dir_time = OS.get_ticks_msec() + react_time
		#self.move_local_x(2)
	elif(Player.position.y > self.position.y and next_dir_y != 1):
		next_dir_y = 1
		next_dir_time_y = OS.get_ticks_msec() + react_time
		#self.move_local_y(2)
	elif(Player.position.y < self.position.y and next_dir_y != -1):
		next_dir_y = -1
		next_dir_time_y = OS.get_ticks_msec() + react_time
		#self.move_local_y(-2)
	elif(Player.position.y == self.position.y and next_dir_y != 0):
		next_dir_y = 0
		next_dir_time = OS.get_ticks_msec() + react_time
	
	if(OS.get_ticks_msec() > next_dir_time):
		dir = next_dir
	if(OS.get_ticks_msec() > next_dir_time_y):
		dir_y = next_dir_y
		
	vel.x = dir * 500
	vel.y = dir_y * 500
	
	vel = move_and_slide(vel, Vector2(0, -1))
