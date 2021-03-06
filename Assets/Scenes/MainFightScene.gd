extends Node2D
var enemy_count = 1
var start_game = false
var wave_num = 1
var new_wave = false
var start_next_wave = false
var spear_spawn = false
export (PackedScene) var enemy_scene
export (PackedScene) var heavy_enemy_scene
export (PackedScene) var spear_pickup_scene
export (PackedScene) var health_pickup_scene
var enemy
var heavy_enemy
var spear_pickup
var health_pickup
var scene_path_to_load
var rng = RandomNumberGenerator.new()
var rngTimer = RandomNumberGenerator.new()
var spear_count_array = []
var health_count_array = []

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _ready():
	$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.wait_time = 2
	#heavy_enemy = heavy_enemy_scene.instance()
	#self.add_child(heavy_enemy)
	#heavy_enemy.position = Vector2(500, 500)
	#rng.randomize()
	rngTimer.randomize()
	#var random_spear_location = rng.randf_range(0, 1000)
	#var random_spear_spawn_timer = rng.randf_range(1, 20)
	#add_spear(random_spear_location)
	#$SpearSpawnTimer.wait_time = random_spear_spawn_timer
	
	wave_1()
	$AudioStreamPlayer2D.play_wave_noise()
	#$HealthSpawnTimer.start()

func start_game():
	$Player.action = false
	#$SpearSpawnTimer.start()
	$Music.play_battle_music()
	
func play_win():
	scene_path_to_load = "res://Scenes/WinScreen.tscn"
	get_node("/root/GameStateManager").getScene(scene_path_to_load)	

func play_lose():
	
		print("loading scene")
		scene_path_to_load = "res://Scenes/LoseScreen.tscn"
		get_node("/root/GameStateManager").getScene(scene_path_to_load)
	
func get_enemy_number():
	match wave_num:
		1: enemy_count = 1
		2: enemy_count = 3
		3: enemy_count = 5
		4: enemy_count = 2
		5: enemy_count = 4
	return enemy_count

func play_battle_music():
	$Music.play_battle_music()

func startSpearTimer():
	$SpearSpawnTimer.start()

# Add spear to random location on map
func add_spear(ran_num_x, ran_num_y):
	# Make sure the spear pickups are always X or less. Dont want to many spears on map
	if(get_spear_count_on_ground() <= 2):
		spear_pickup = spear_pickup_scene.instance()
		self.add_child(spear_pickup)
		spear_pickup.position = Vector2(ran_num_x,ran_num_y)
		spear_count_array.append(spear_pickup)

# Add health pickup to random location on map
func add_health(ran_num_x, ran_num_y):
	if(get_health_count_on_ground() <= 2):
		health_pickup = health_pickup_scene.instance()
		self.add_child(health_pickup)
		health_pickup.position = Vector2(ran_num_x,ran_num_y)
		health_count_array.append(health_pickup)

func add_health_enemy_drop(x_pos, y_pos):
	health_pickup = health_pickup_scene.instance()
	self.add_child(health_pickup)
	health_pickup.position = Vector2(x_pos, y_pos)

# Remove spear from the spear count array
func remove_spear_from_array():
	spear_count_array.remove(0)

# Remove health from the health count array
func remove_health_from_array():
	health_count_array.remove(0)

# Get the spear pickup count on map
func get_spear_count_on_ground():
	return spear_count_array.size()

# Get the health pickup count on map
func get_health_count_on_ground():
	return health_count_array.size()

func start_new_wave():
	wave_num += 1
	if(wave_num >= 6):
		play_win()
	get_enemy_number()
	$CanvasLayer/Control/NinePatchRect/Wave_Large.change_wave()
	$CanvasLayer/Control/NinePatchRect/Wave_Small.progress()
	
	match wave_num:
		#1: wave_1()
		2: wave_2()
		3: wave_3()
		4: wave_4()
		5: wave_5()
	#for i in range(enemy_count):
	#	enemy = enemy_scene.instance()
	#	add_child(enemy)
	#	enemy.position = Vector2(100 + (i*100), i*100)
	new_wave = false
	start_next_wave = false

func wave_1():
	var enemy1 = enemy_scene.instance()
	add_child(enemy1)
	enemy1.position = Vector2(1200, 550)
	
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
	enemy3.position = Vector2(1500, 350)
	
	var enemy4 = enemy_scene.instance()
	add_child(enemy4)
	enemy4.position = Vector2(1500, 750)
	
	#var enemy5 = enemy_scene.instance()
	#add_child(enemy5)
	#enemy5.position = Vector2(100, 750)
	
func wave_4():
	var heavy_enemy1 = heavy_enemy_scene.instance()
	add_child(heavy_enemy1)
	heavy_enemy1.position = Vector2(250, 500)
	
	#var heavy_enemy2 = heavy_enemy_scene.instance()
	#add_child(heavy_enemy2)
	#heavy_enemy2.position = Vector2(1500, 500)
	
func wave_5():
	var heavy_enemy1 = heavy_enemy_scene.instance()
	add_child(heavy_enemy1)
	heavy_enemy1.position = Vector2(250, 350)
	
	var heavy_enemy2 = heavy_enemy_scene.instance()
	add_child(heavy_enemy2)
	heavy_enemy2.position = Vector2(250, 750)
	
	var heavy_enemy3 = heavy_enemy_scene.instance()
	add_child(heavy_enemy3)
	heavy_enemy3.position = Vector2(1500, 350)
	
	#var heavy_enemy4 = heavy_enemy_scene.instance()
	#add_child(heavy_enemy4)
	#heavy_enemy2.position = Vector2(1500, 750)
	
func _process(delta):
	
	if $CanvasLayer/Control/Wave_Enemy_Spawn_Timer.time_left <= 0.1 && start_next_wave == true:
		start_new_wave()
	if get_tree().get_nodes_in_group("Enemy1").size() <= 0 && get_tree().get_nodes_in_group("Enemy2").size() <= 0 && new_wave == false:
		new_wave = true
		start_next_wave = true
		$CanvasLayer/Control/Wave_Enemy_Spawn_Timer.start()

### Timer for randomizing spear location / spawn time
func _on_SpearSpawnTimer_timeout():
	rng.randomize()
	var random_spear_location_x = rng.randf_range(75, 1750)
	var random_spear_location_y = rng.randf_range(75, 800)
	var random_spear_spawn_timer = rng.randf_range(15, 50)
	add_spear(random_spear_location_x, random_spear_location_y)
	$SpearSpawnTimer.wait_time = 5
	$SpearSpawnTimer.stop()
	#$SpearSpawnTimer.wait_time = random_spear_spawn_timer
	#$SpearSpawnTimer.start()


#func _on_HealthSpawnTimer_timeout():
#	rngTimer.randomize()
#	var random_health_location_x = rngTimer.randf_range(75, 1750)
#	var random_health_location_y = rngTimer.randf_range(75, 800)
#	var random_health_spawn_timer = rngTimer.randf_range(15, 30)
#	add_health(random_health_location_x, random_health_location_y)
#	$HealthSpawnTimer.wait_time = random_health_spawn_timer
#	$HealthSpawnTimer.start()
