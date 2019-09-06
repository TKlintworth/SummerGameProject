extends Node2D
var enemy_count = 1
var wave_num = 1
var new_wave = false
var progress = false
var scene_path_to_load

func _ready():
	$Fog/icon/AnimationPlayer.play("fog_in")
	progress = false
	#wave_num = 1
	#enemy_count = 1
	print("wave 2 open")
	set_process(false)
	
func destroy_spear():
	remove_child($Spear)
	
func destroy_enemy():
	remove_child($Enemy)
	enemy_count -= 1
	if enemy_count <= 0:
		new_wave_start()
	
func new_wave_start():
	$Fog/icon/AnimationPlayer.play("new_wave") #Plays shader
	wave_num += 1
	new_wave = true
	set_process(true)
	$CanvasLayer/Control/Timer.wait_time = 2 #Set wait timer for wave text
	$CanvasLayer/Control/Timer.start()

func play_wave_text(): # Wave transition
	new_wave = false
	progress = true
	print("wave: ")
	print(wave_num)
	scene_path_to_load = "res://Scenes/Wave2.tscn"
	get_tree().change_scene(scene_path_to_load)
	$CanvasLayer/Control/NinePatchRect/Wave_Small.progress() # increases wave count and plays wave text
	set_process(false)
	
func get_enemy_number():
	match wave_num:
		1: enemy_count = 1
		2: enemy_count = 3
		3: enemy_count = 5
	return enemy_count

func _process(delta):
	if $CanvasLayer/Control/Timer.time_left <= 0.1 && new_wave == true: # time to play the wave text
		play_wave_text()
	