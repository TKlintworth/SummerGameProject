extends KinematicBody2D

onready var Player = get_parent().get_node("Player")

var react_time = 0
var dir = 0
var next_dir = 0
var next_dir_time = 0
var vel = Vector2(0,0)

func _ready():
	set_process(true)


func _process(delta):
	$AnimatedSprite.play("redguard_idle")
	var difference = Player.position.y - self.position.y
	if(difference < 1 and difference > -1):
		vel.y = 0
	elif(Player.position.y < self.position.y and next_dir != -1):
		vel.y = -200
	elif(Player.position.y > self.position.y and next_dir != 1):
		vel.y = 200
	vel = move_and_slide(vel)
