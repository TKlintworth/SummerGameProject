extends Node2D
var enemy_count = 1
var wave_num = 1
var new_wave = false
var start_next_wave = false
export (PackedScene) var enemy_scene
var enemy

func _ready():
	$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.wait_time = 2
	#$Fog/icon/AnimationPlayer.play("fog_in") # play fog shader at start of game
	#set_process(false) # set process to false to make less expensive
	#print(get_tree().get_nodes_in_group("Enemy1").size())
	
func destroy_spear():
	remove_child($Spear)
	
#func destroy_enemy():
#	remove_child($Enemy)
#	enemy_count -= 1
#	if enemy_count <= 0:
#		new_wave_start()
	
#func new_wave_start():
#	$Fog/icon/AnimationPlayer.play("new_wave") #Plays shader
#	wave_num += 1
	#new_wave = true
#	get_enemy_number()
#	set_process(true)
#	$CanvasLayer/Control/Timer.wait_time = 2 #Set wait timer for wave text
#	$CanvasLayer/Control/Timer.start()
	

#func play_wave_text(): # Wave transition
	#new_wave = false
#	start_next_wave = true
#	$CanvasLayer/Control/NinePatchRect/Wave_Small.progress() # increases wave count and plays wave text
#	$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.wait_time = 5 #Set wait timer for enemy wave to spawn
#	$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.start()
	
	
	
func get_enemy_number():
	match wave_num:
		1: enemy_count = 1
		2: enemy_count = 3
		3: enemy_count = 5
	return enemy_count

#func start_wave_2():
#	set_process(false)
#	for i in range(enemy_count):
#		enemy = enemy_scene.instance()
#		add_child(enemy)
#		enemy.position = Vector2(100 + (i*100), i*100)

func play_battle_music():
	$Music.play_battle_music()

func start_new_wave():
	wave_num += 1
	get_enemy_number()
	$CanvasLayer/Control/NinePatchRect/Wave_Large.change_wave()
	$CanvasLayer/Control/NinePatchRect/Wave_Small.progress()
	print("enemy count")
	print(enemy_count)
	for i in range(enemy_count):
		enemy = enemy_scene.instance()
		add_child(enemy)
		enemy.position = Vector2(100 + (i*100), i*100)
	new_wave = false
	start_next_wave = false
	
func _process(delta):
	#if $CanvasLayer/Control/Timer.time_left <= 0.1 && new_wave == true: # time to play the wave text
	#	play_wave_text()
	if $CanvasLayer/Control/Wave_Enemy_Spawn_Timer.time_left <= 0.1 && start_next_wave == true:
		start_new_wave()
	if get_tree().get_nodes_in_group("Enemy1").size() <= 0 && new_wave == false:
		new_wave = true
		start_next_wave = true
		print("new wave")
		$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.start()
		
	
	