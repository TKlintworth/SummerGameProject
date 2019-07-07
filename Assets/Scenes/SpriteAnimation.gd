extends KinematicBody2D

var velocity = Vector2()
var look_direction = Vector2(-1,0)
export (int) var speed = 360

#var spear_point_pos
export var spear_attack_bool = false
export var character_direction = 0 # int value to decide direction; 0 = Character is facing LEFT; 1 = Character is facing RIGHT
export (PackedScene) var spear_scene

var spear_ready
var player_dead = false
var player_block = false # boolean for if player is blocking
var action = false # boolean for if player is performing an action. E.G. blocking, attacking
var spear
var spear_thrown = false
var player_idle = false
export var status = 0 # int value to decide animation type; 0 = Does have spear; 1 = Does NOT have spear
var spear_pick
var delay = 1
var waited = 0

onready var player_health_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/TextureProgress")
onready var player_stamina_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/TextureProgress2")
var main_scene = load("res://Scenes/MainFightScene.gd").new()

func _ready():
	status = 0 # status of 0 is slave with spear

# take damage function
func take_damage():
	player_health_node.value -= 2

# player block function
func block():
	player_block = true
	action = true
	player_stamina_node.value -= 2
	$AnimatedSprite.play("slave_block")
	
# throw spear function	
func throw_spear():
	spear_thrown = true
	action = true
	spear = spear_scene.instance()
	get_parent().add_child(spear) # adds the spear "object" to the scene
	spear_pick = get_parent().get_node("Spear/Area2D")
	print(spear_pick)
	match character_direction:
		0: spear.position = Vector2((self.position.x - 120), (self.position.y - 30)) # set starting position of spear when player is facing left
		1: spear.position = Vector2((self.position.x + 120), (self.position.y - 30)) # set starting postion of spear when player is facing right
	$AnimatedSprite.play("slave_throw_spear_active")

func get_input():
	velocity = Vector2()
	var sprint = false
	
	if (player_health_node.value <=27):
		player_dead = true
		$AnimatedSprite.play("slave_dying")
		
	########### MOVEMENT #################
	if Input.is_action_pressed("left") && action == false:
		look_direction = Vector2(-1,0)
		velocity.x -= 1
		$AnimatedSprite.set_flip_h(false)
		character_direction = 0 
		match status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")	
	if Input.is_action_pressed("right") && action == false:
		look_direction = Vector2(1,0)
		velocity.x += 1
		$AnimatedSprite.set_flip_h(true)
		character_direction = 1
		match status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
	if Input.is_action_pressed("down") && action == false:
		look_direction = Vector2(0,1)
		velocity.y += 1
		match status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
	if Input.is_action_pressed("up") && action == false:
		look_direction = Vector2(0,-1)
		velocity.y -= 1
		match status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")
			
	############# ACTIONS ###########################
	# Block action
	if Input.is_action_pressed("E"): #block animation
		block()
	
	# Throw spear action
	if Input.is_action_pressed("T") && spear_thrown == false: # player has not thrown spear yet
		throw_spear()
	
	#Die action
	if Input.is_action_pressed("Q"):
		player_dead = true
		$Area2D/AudioStreamPlayer2D.play_noise()
		$AnimatedSprite.play("slave_dying")
		
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
		match status:
			0: $AnimatedSprite.play("player_idle_spear") # player has not thrown spear yet
			1: $AnimatedSprite.play("slave_idle") # player has thrown spear
			
	if sprint == false:
		velocity = velocity.normalized() * speed
#	if(Input.is_key_pressed(KEY_Y)):
#		take_damage()
	else:
		#sprinting increases speed by 150%
		velocity = velocity.normalized() * (speed+ (0.5*(speed)))

func _physics_process(delta):
	if(spear_thrown == true && spear_pick.spear_pickup == true): # spear has been thrown, and player has entered the Area2D of the spear, spear has not hit enemy
		get_parent().destroy_spear() # destroys the spear node in the main fight scene
		spear_thrown = false
		status = 0 # player is now holding the spear
	elif(spear_thrown == true && spear_pick.spear_gone == true): # spear has been thrown, it has hit the enemy
		get_parent().destroy_spear() # destroys the spear node in the main fight scene
		get_parent().destroy_enemy() # destroys the enemy node in the main fight scene
		status = 1 # player is now without the spear
	
	get_input()
	velocity = move_and_slide(velocity)

######### Plays after each animation finished ############
func _on_AnimatedSprite_animation_finished(): #ran everytime animation is finished
	player_block = false
	if !Input.is_action_pressed("E"): #this is needed so player does cannot move when animation plays
		action = false
	if spear_thrown == true:
		status = 1
	else:
		status = 0
	
#&& spear_ready == true && player_dead == false

#func _physics_process(delta):
#	if (player_node.value <=27) :
#		player_dead = true
#		$AnimatedSprite.play("slave_dying")
#	elif(Input.is_key_pressed(KEY_LEFT) && spear_ready == true && player_dead == false):
#		$AnimatedSprite.set_flip_h(false)
#		$Area2D.position.x = spear_point_pos
#		$AnimatedSprite.play("slave_spear_running")
#		vel.x = -300
#		left = true
#		right = false
#		down = false
#		up = false
#	elif(Input.is_key_pressed(KEY_RIGHT) && spear_ready == true && player_dead == false):
#		$AnimatedSprite.set_flip_h(true)
#		$Area2D.position.x = spear_point_pos * (-1)
#		$AnimatedSprite.play("slave_spear_running")
#		vel.x = 300
#		left = false
#		right = true
#		down = false
#		up = false
#	elif(Input.is_key_pressed(KEY_DOWN) && spear_ready == true && player_dead == false):
#		$AnimatedSprite.play("slave_spear_running")
#		vel.y = 300
#		left = false
#		right = false
#		down = true
#		up = false
#	elif(Input.is_key_pressed(KEY_UP) && spear_ready == true && player_dead == false):
#		$AnimatedSprite.play("slave_spear_running")
#		vel.y = -300
#		left = false
#		right = false
#		down = false
#		up = true
#	elif(Input.is_key_pressed(KEY_T) && player_dead == false):
#		spear_ready = false
#		$Area2D.show()
#		$AnimatedSprite.play("slave_jab_spear_active")
#		if $AnimatedSprite.flip_h == false:
#			$Area2D/AnimationPlayer.play("spear_attack_left")
#		if $AnimatedSprite.flip_h == true:
#			$Area2D/AnimationPlayer.play("spear_attack_right")
#		spear_attack_bool = true
#	else:
#		if(spear_ready == true && player_dead == false):
#			$AnimatedSprite.play("slave_jab_spear_inactive")
#			vel.x = 0
#			vel.y = 0
#
#	vel = move_and_slide(vel)

#func _input(event):
#	if(event.is_action_pressed("shoot")):
#		$AnimatedSprite.play("idle")




