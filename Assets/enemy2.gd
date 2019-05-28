extends KinematicBody2D

onready var Player = get_parent().get_node("BoxKinematic")

var react_time = 0
var dir = 0
var next_dir = 0
var next_dir_time = 0
var vel = Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	var difference = Player.position.y - self.position.y
	if(difference < 1 and difference > -1):
		vel.y = 0
	elif(Player.position.y < self.position.y and next_dir != -1):
		#next_dir = -1
		#next_dir_time = OS.get_ticks_msec() + react_time
		vel.y = -100
	elif(Player.position.y > self.position.y and next_dir != 1):
		vel.y = 100
		#next_dir = 1
		#next_dir_time = OS.get_ticks_msec() + react_time
		
	#if(OS.get_ticks_msec() >= next_dir_time):
		#dir = next_dir
	
	#vel.y = dir * 100
	
	vel = move_and_slide(vel)
