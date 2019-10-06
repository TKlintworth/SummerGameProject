extends Node2D
var enemy_count = 1
var wave_num = 1
var new_wave = false
var start_next_wave = false
var spear_spawn = false
export (PackedScene) var enemy_scene
export (PackedScene) var heavy_enemy_scene
export (PackedScene) var spear_pickup_scene
var enemy
var heavy_enemy
var spear_pickup
var scene_path_to_load
var rng = RandomNumberGenerator.new()
var rngTimer = RandomNumberGenerator.new()

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
    	OS.window_fullscreen = !OS.window_fullscreen

func _ready():
	$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.wait_time = 2
	heavy_enemy = heavy_enemy_scene.instance()
	self.add_child(heavy_enemy)
	heavy_enemy.position = Vector2(500, 500)
	#rng.randomize()
	rngTimer.randomize()
	#var random_spear_location = rng.randf_range(0, 1000)
	var random_spear_spawn_timer = rng.randf_range(1, 20)
	#add_spear(random_spear_location)
	$SpearSpawnTimer.wait_time = random_spear_spawn_timer
	$SpearSpawnTimer.start()
	
func play_win():
	scene_path_to_load = "res://Scenes/WinScreen.tscn"
	get_node("/root/GameStateManager").getScene(scene_path_to_load)	
	
func get_enemy_number():
	match wave_num:
		1: enemy_count = 1
		2: enemy_count = 3
		3: enemy_count = 5
	return enemy_count

func play_battle_music():
	$Music.play_battle_music()

# Add spear to random location on map
func add_spear(ran_num):
	spear_pickup = spear_pickup_scene.instance()
	self.add_child(spear_pickup)
	spear_pickup.position = Vector2(ran_num,ran_num)

func start_new_wave():
	wave_num += 1
	if(wave_num >= 4):
		play_win()
	get_enemy_number()
	$CanvasLayer/Control/NinePatchRect/Wave_Large.change_wave()
	$CanvasLayer/Control/NinePatchRect/Wave_Small.progress()
	print("enemy count")
	print(enemy_count)
	
	match wave_num:
		2: wave_2()
		3: wave_3()
		3: wave_4()
		5: wave_5()
	#for i in range(enemy_count):
	#	enemy = enemy_scene.instance()
	#	add_child(enemy)
	#	enemy.position = Vector2(100 + (i*100), i*100)
	new_wave = false
	start_next_wave = false
	
func wave_2():
	# 3 Enemies in this wave
	var enemy1 = enemy_scene.instance()
	add_child(enemy1)
	enemy1.position = Vector2(250, 350)
	
	var enemy2 = enemy_scene.instance()
	add_child(enemy2)
	enemy2.position = Vector2(250, 750)
	
	var enemy3 = enemy_scene.instance()
	add_child(enemy3)
	enemy3.position = Vector2(1500, 500)
	
func wave_3():
	var enemy1 = enemy_scene.instance()
	add_child(enemy1)
	enemy1.position = Vector2(250, 350)
	
	var enemy2 = enemy_scene.instance()
	add_child(enemy2)
	enemy2.position = Vector2(250, 750)
	
	var enemy3 = enemy_scene.instance()
	add_child(enemy3)
	enemy3.position = Vector2(1500, 500)
	
	var enemy4 = enemy_scene.instance()
	add_child(enemy4)
	enemy4.position = Vector2(1500, 1000)
	
	var enemy5 = enemy_scene.instance()
	add_child(enemy5)
	enemy5.position = Vector2(100, 1000)
	
func wave_4():
	pass
func wave_5():
	pass
func _process(delta):
	
	if $CanvasLayer/Control/Wave_Enemy_Spawn_Timer.time_left <= 0.1 && start_next_wave == true:
		start_new_wave()
	if get_tree().get_nodes_in_group("Enemy1").size() <= 0 && new_wave == false:
		new_wave = true
		start_next_wave = true
		$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.start()

### Timer for randomizing spear location / spawn time
func _on_SpearSpawnTimer_timeout():
	rng.randomize()
	rngTimer.randomize()
	print("added spear")
	var random_spear_location = rng.randf_range(50, 550)
	var random_spear_spawn_timer = rng.randf_range(15, 50)
	add_spear(random_spear_location)
	$SpearSpawnTimer.wait_time = random_spear_spawn_timer
	$SpearSpawnTimer.start()
