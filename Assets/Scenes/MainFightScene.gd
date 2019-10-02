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
	for i in range(enemy_count):
		enemy = enemy_scene.instance()
		add_child(enemy)
		enemy.position = Vector2(100 + (i*100), i*100)
	new_wave = false
	start_next_wave = false
	
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
