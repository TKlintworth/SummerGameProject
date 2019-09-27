extends Area2D

export var spear_pickup = false
var main_scene = load("res://Scenes/MainFightScene.gd").new()
var player_status
var spear_gone = false # tells if spear has hit enemy or not

func _ready():
	spear_pickup = false
	player_status = get_tree().get_root().get_node("MainRoot/Player").player_status