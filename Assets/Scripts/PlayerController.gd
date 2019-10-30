extends KinematicBody2D

var velocity = Vector2()
var look_direction = Vector2(-1,0)
export (int) var speed = 360

#var spear_point_pos
export var spear_attack_bool = false
export var character_direction = 0 # int value to decide direction; 0 = Character is facing LEFT; 1 = Character is facing RIGHT
export (PackedScene) var spear_scene
export (PackedScene) var spear_on_ground

#var spear_ready
var player_dead = false
var dead_animation_played = false
var player_block = false # boolean for if player is blocking
var action = false # boolean for if player is performing an action. E.G. blocking, attacking
var spear
var spear_thrown = false
export var player_status = 0 # int value to decide animation type; 0 = Does have spear; 1 = Does NOT have spear
var spear_pick
var game_status = 0 # game is a go
var enemy_area_array = []


onready var player_health_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/Health")
onready var player_stamina_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/Stamina")
#onready var mainScene = get_node("MainFightScene")

func set_player_dead(choice):
	if choice == true:
		player_dead = true
		#player_die()
	else:
		player_dead = false

func _ready():
	game_status = 0
	player_status = 0 # status of 0 is slave with spear
	character_direction = 1 # player starts facing right
	$AnimatedSprite.set_flip_h(true) # make player face right
	$EnemyDamageArea.set_monitoring(false)
	#print(get_parent().get_node("ColorRect/AnimationPlayer").play("transition_in"))
	
############## FUNCTIONS ################
# take damage function
func take_damage(amount):
	#player_health_node.value -= 2
	if (player_health_node.value - amount) <= 0:
		#Player dies
		#player_die()
		player_health_node.set_value(0)
		get_parent().play_lose()
	else:
		player_health_node.set_value(player_health_node.value - amount)
	
# function for player death
func player_die():
	if player_dead == true && dead_animation_played == false:
		#take_damage(100)
		$AudioStreamPlayer2D.play_noise()
		$AnimatedSprite.play("slave_dying")
		game_status = 1
		dead_animation_played = true # prevents audio stream from playing sounds more than once
		
# player block function
func block():
	player_block = true
	action = true
	player_stamina_node.value -= 2
	$AnimatedSprite.play("slave_block")
	
# throw spear function	
func throw_spear():
	#spear_thrown = true
	set_thrown(true)
	action = true
	$AudioStreamPlayer2D.play_attack_noise()
	spear = spear_scene.instance()
	get_parent().add_child(spear) # adds the spear "object" to the scene
	spear_pick = get_parent().get_node("Spear/Area2D")
	match character_direction:
		0: spear.position = Vector2((self.position.x - 50), (self.position.y - 30)) # set starting position of spear when player is facing left
		1: spear.position = Vector2((self.position.x + 50), (self.position.y - 30)) # set starting postion of spear when player is facing right
	$AnimatedSprite.play("slave_throw_spear_active")

func jab():
	action = true
	$AnimatedSprite.play("slave_jab_spear_active")
	$EnemyDamageArea.check_if_enemy_hit()

func get_input():
	velocity = Vector2()
	var sprint = false
	
	#if (player_health_node.value <=27):
	#	player_dead = true
	#	#action = true
	#	player_die()
		
	########### MOVEMENT #################
	if Input.is_action_pressed("left") && action == false:
		look_direction = Vector2(-1,0)
		velocity.x -= 1
		$AnimatedSprite.set_flip_h(false)
		character_direction = 0 
		$RunningDust.position = Vector2(90, 80)
		$RunningDust.process_material.gravity = Vector3(30, -5, 0)
		$RunningDust.process_material.initial_velocity = 20
		$RunningDust.emitting = true
		#$RunningDust.gravity = Vector3(-30, 0, 0)
		match player_status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")	
	if Input.is_action_pressed("right") && action == false:
		look_direction = Vector2(1,0)
		velocity.x += 1
		$AnimatedSprite.set_flip_h(true)
		character_direction = 1
		$RunningDust.position = Vector2(-90, 80)
		$RunningDust.process_material.gravity = Vector3(-30, -5, 0)
		$RunningDust.process_material.initial_velocity = -20
		$RunningDust.emitting = true
		match player_status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
	if Input.is_action_pressed("down") && action == false:
		look_direction = Vector2(0,1)
		velocity.y += 1
		match player_status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
	if Input.is_action_pressed("up") && action == false:
		look_direction = Vector2(0,-1)
		velocity.y -= 1
		match player_status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
			
	############# ACTIONS ###########################
	# Block action
	if Input.is_action_pressed("E") && spear_thrown == false: #block animation
		#get_parent().get_node("ColorRect/AnimationPlayer").play("transition_in")
		block()
	
	# Throw spear action
	if Input.is_action_pressed("T") && spear_thrown == false: # player has not thrown spear yet
		throw_spear()
	
	# Jab action
	if Input.is_action_pressed("space") && get_thrown() == false:
		jab()
	
	#Sprint action
	if Input.is_action_pressed("shift"):
		$AnimatedSprite.set_speed_scale(1.5)
		$AnimatedSprite.play("player_run_spear")
		sprint = true
	else:
		sprint = false
		$AnimatedSprite.set_speed_scale(1)
		
	# Standing player
	if Input.is_action_pressed("left") == false && Input.is_action_pressed("down") == false && Input.is_action_pressed("right") == false && Input.is_action_pressed("up") == false && player_dead == false && player_block == false && action == false:
		match player_status:
			0: $AnimatedSprite.play("player_idle_spear") # player has not thrown spear yet
			1: $AnimatedSprite.play("slave_idle") # player has thrown spear
			
	if sprint == false:
		velocity = velocity.normalized() * speed
#	if(Input.is_key_pressed(KEY_Y)):
#		take_damage()
	else:
		#sprinting increases speed by 150%
		velocity = velocity.normalized() * (speed+ (0.5*(speed)))

# Setter for player_status
func set_player_status(status):
	match status:
		0: player_status = 0
		1: player_status = 1
	
# Setter for spear_thrown bool 	
func set_thrown(spear_thrown):
	self.spear_thrown = spear_thrown

# Getter for spear_thrown bool
func get_thrown():
	return self.spear_thrown
	
func _physics_process(delta):
	if $AnimatedSprite.get_animation() == "slave_jab_spear_active":
		if $AnimatedSprite.frame == 4:
			$EnemyDamageArea.set_monitoring(true)
			#$EnemyDamageArea.set_collision_mask(2)
		if $AnimatedSprite.frame >= 5:
			$EnemyDamageArea.set_monitoring(false)
	match game_status: # if player is alive, get input. Otherwise, do not get input
		0: get_input()
		1: pass
	velocity = move_and_slide(velocity)

######### Plays after each animation finished ############
func _on_AnimatedSprite_animation_finished(): #ran everytime animation is finished
	player_block = false
	if !Input.is_action_pressed("E"): #this is needed so player does cannot move when animation plays
		action = false
	if spear_thrown == true:
		set_player_status(1)
	else:
		player_status = 0
	$EnemyDamageArea.set_monitoring(false)
	$RunningDust.emitting = false
	#$EnemyDamageArea.set_collision_mask(0) # set player spear to cannot kill enemy
	# GAME OVER, player has died. Return to menu
	#if game_status == 1:
	#	get_node("/root/GameStateManager").getScene("res://Scenes/TitleScreen/TitleScreen.tscn")

#### THESE 2 FUNCTIONS PREVENT KILLING MORE THAN ONE ENEMY IN ONE JAB########
func _on_EnemyDamageArea_area_entered(area):
	if area.name == "DamageArea":
		enemy_area_array.append(area)		
func _on_EnemyDamageArea_area_exited(area):
	
	if(enemy_area_array.size() > 0):
		enemy_area_array.min().get_parent().lose_health_spear_jab()
		if enemy_area_array.min().get_parent().get_health() <= 0:
			enemy_area_array.min().get_parent().play_death()
			#enemy_area_array.min().get_parent().queue_free()
		elif enemy_area_array.min().get_parent().get_health() <= 65:
			if enemy_area_array.min().get_parent().is_in_group("Enemy1"):
				enemy_area_array.min().get_parent().set_speed(200)
			elif enemy_area_array.min().get_parent().is_in_group("Enemy2"):
				enemy_area_array.min().get_parent().set_speed(100)
			enemy_area_array.min().get_parent().play_blood_splash_one_time()
			enemy_area_array.min().get_parent().play_blood_flow()
		elif enemy_area_array.min().get_parent().get_health() <= 100:
			if enemy_area_array.min().get_parent().is_in_group("Enemy1"):
				enemy_area_array.min().get_parent().play_blood_one_time()
		enemy_area_array.clear()
####################################################################

	


#func _on_EnemyDamageArea_body_shape_entered(body_id, body, body_shape, area_shape):
#		print("area id: ")
#		print(body_id)
#		print("shape: ")
#		print(area_shape)


#func _on_EnemyDamageArea_area_shape_entered(area_id, area, area_shape, self_shape):
#	if area.name == "DamageArea":
#		print("area id: ")
#		print(area_id)
#		print("area shape: ")
#		print(area_shape)
#		print("self shape: ")
#		print(self_shape)
		




