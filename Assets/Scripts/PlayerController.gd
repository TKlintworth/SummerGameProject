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
var spearCooldown = 10.0 # How long before you can throw your spear again
var spearThrowable = true # Is the spear throwable (i.e., no cooldown left)
var player_dead = false
var dead_animation_played = false
var player_block = false # boolean for if player is blocking
var action = true # boolean for if player is performing an action. E.G. blocking, attacking
var game_started = false
var spear
var spear_thrown = false
export var player_status = 0 # int value to decide animation type; 0 = Does have spear; 1 = Does NOT have spear
var spear_pick
var game_status = 0 # game is a go
var enemy_area_array = []
# How much stamina should the player regenerate per second
var stamina_regen_value = 4
# How much stamina should sprinting cost per second
var stamina_sprint_value = 4
var sprint
var stamina_depleted = false # Bool to tell if player has used up all stamina
var staminaStopRegenTime = 2 # penalty for having 0 stamina
var spear_picked_up = false
var tween

onready var player_health_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/Health")
onready var player_stamina_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/Stamina")
onready var screen_flash = get_parent().get_node("CanvasLayer/ScreenFlash")
onready var knockbackEffect = get_node("knockbackEffect")
onready var spearIcon = get_parent().get_node("CanvasLayer/Control/NinePatchRect/SpearThrow")

var knockbackDistance = 50
var knockbackDirection

func set_player_dead(choice):
	if choice == true:
		player_dead = true
		#player_die()
	else:
		player_dead = false

func _ready():
	$AnimatedSprite.play("player_idle_spear")
	#for i in 5:
	#	$AnimationPlayer.play("blink")
	$AnimatedSprite.set_speed_scale(1)
	game_status = 0
	player_status = 0 # status of 0 is slave with spear
	character_direction = 1 # player starts facing right
	$AnimatedSprite.set_flip_h(true) # make player face right
	$EnemyDamageArea.set_monitoring(false)
	action = true
	
	#Create a timer to handle stamina regeneration
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_stamina_timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start() #to start


############## FUNCTIONS ################


# Stamina regeneration if the players alive and stamina is less than max
func stamina_regen():
	# Decrease stamina if sprinting
	if sprint == true:
		lose_stamina(stamina_sprint_value)
	if player_dead == false and player_stamina_node.value < 87 and sprint == false and !stamina_depleted:
		#print("Regen stamina")
		if player_stamina_node.value >= 87:
			player_stamina_node.value = 87 
		else: 
			player_stamina_node.value += stamina_regen_value


func _on_stamina_timer_timeout():
   stamina_regen()

# take damage function
func take_damage(amount):
	#player_health_node.value -= 2
	if (player_health_node.value - amount) <= 28:
		#Player dies
		player_dead = true
		player_health_node.set_value(0)	
		player_die()
			
			
	else:
		player_health_node.set_value(player_health_node.value - amount)

func lose_stamina(amount):
	player_stamina_node.value -= amount
	if player_stamina_node.value <= 28:
		player_stamina_node.value = 28

func increase_health(amount):
	if(player_health_node.value + amount >= 90):
		player_health_node.set_value(90)
	else:
		player_health_node.set_value(player_health_node.value + amount)
	
# function for player death
func player_die():
	if player_dead == true && dead_animation_played == false:
		#take_damage(100)
		#$AudioStreamPlayer2D.play_noise()
		get_tree().get_root().get_node("MainRoot/AudioStreamPlayer2D").play_enemy_death_noise()
		$AnimatedSprite.play("slave_dying")
		game_status = 1
		dead_animation_played = true # prevents audio stream from playing sounds more than once
		get_tree().get_root().get_node("MainRoot/DeathTimer").start()
		
	
func stamina_penalty_timer():
	stamina_depleted = true
	yield(get_tree().create_timer(staminaStopRegenTime), "timeout")
	stamina_depleted = false

# This function is necessary to set the direction for the player to get knocked back after being hit by enemy while blocking
func setKnockbackDirection(direction):
	knockbackDirection = -direction

# Player is knocked back when hit by heavy enemy while blocking
func knockback():
	var newPos = position + (knockbackDistance * -knockbackDirection)
	knockbackEffect.interpolate_property(self, "position", null, newPos, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	knockbackEffect.start()		
	
# player block function
# Enemy functions directly decrease Player stamina rather than being handled in the block function
func block():
	# If the player has a spear (status 0) allow blocking ability. If no spear, disallow blocking.
	if player_status == 0 && player_stamina_node.value >= 29:
		player_block = true
		action = true
		stamina_depleted = false
		$AnimatedSprite.play("slave_block")
	else:
		action = false
		player_block = false
		stamina_depleted = true
		stamina_penalty_timer()
		print("Unable to block / no weapon")

# Emits spear destruction particle effect and sets player to not have spear
func spear_destroy_from_enemy():
	$SpearDestruction.emitting = true
	if (self.player_status == 0): # if player has spear, set player to not have spear
		set_thrown(true)
		$AnimatedSprite.play("slave_idle")
		get_tree().get_root().get_node("MainRoot").startSpearTimer()
		self.player_status = 1

func reset_spear_icon():
	print('reset')
	tween.set_active(false)
	self.set_thrown(false)
	spearIcon.set_value(10)

# Function to handle spear throwing
func throw_spear():
	if spearThrowable:
		# Unable to throw spear until cooldown timer elapses
		spearThrowable = false
		
			# Timer duration determined by spearCooldown variable
		get_node("SpearCooldownTimer").wait_time = spearCooldown
		get_node("SpearCooldownTimer").start()
		
		spearIcon.set_max(spearCooldown)
		
		# Cooldown visual timer clockwise
		# Tween between the max and min value for the texture progress node's value
		tween = get_parent().get_node("CanvasLayer/Control/NinePatchRect/SpearThrow/Tween")
		tween.interpolate_property(spearIcon, "value",
		0, 10, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		set_thrown(true)
		action = true
		get_parent().get_node("AudioStreamPlayer2D").play_attack_noise()
		spear = spear_scene.instance()
		get_parent().add_child(spear) # adds the spear "object" to the scene
		spear_pick = get_parent().get_node("Spear/Area2D")
		match character_direction:
			0: spear.position = Vector2((self.position.x - 50), (self.position.y - 30)) # set starting position of spear when player is facing left
			1: spear.position = Vector2((self.position.x + 50), (self.position.y - 30)) # set starting postion of spear when player is facing right
		$AnimatedSprite.play("slave_throw_spear_active")
	else:
		# Wait for cooldown timer to elapse before throwing again
		print("Wait ", get_node("SpearCooldownTimer").time_left, " longer!")


func jab():
	action = true
	get_parent().get_node("AudioStreamPlayer2D").play_attack_noise()
	$AnimatedSprite.set_speed_scale(3.5)
	$AnimatedSprite.play("slave_jab_spear_active")
	$EnemyDamageArea.check_if_enemy_hit()
	yield(get_node("AnimatedSprite"), "animation_finished")
	

func get_input():
	velocity = Vector2()
	sprint = false
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
	if Input.is_action_pressed("E") && spear_thrown == false && !stamina_depleted: #block animation
		#get_parent().get_node("ColorRect/AnimationPlayer").play("transition_in")
		print("Player Blocking")
		block()
		
	
	# Throw spear action
	if Input.is_action_pressed("T") and !spear_thrown and !action: # player has not thrown spear yet
		throw_spear()
	
	# Jab action
	if Input.is_action_just_pressed("space") and !action:
		jab()
	
	#Sprint action
	if Input.is_action_pressed("shift") and !action and player_stamina_node.value > 3:
		$AnimatedSprite.set_speed_scale(1.5)
		match player_status:
			0: $AnimatedSprite.play("player_run_spear")
			1: $AnimatedSprite.play("slave_running")		
		sprint = true
	else:
		sprint = false
		#$AnimatedSprite.set_speed_scale(1)
		
	# Standing player
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("down") and !Input.is_action_pressed("right") and !Input.is_action_pressed("up") and !player_dead and !player_block and !action:
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
		0: player_status = 0 # has spear
		1: player_status = 1 # no spear
	
# Setter for spear_thrown bool 	
func set_thrown(spear_thrown):
	self.spear_thrown = spear_thrown

# Getter for spear_thrown bool
func get_thrown():
	return self.spear_thrown

func set_throwable(value):
	self.spearThrowable = value

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

	$EnemyDamageArea.set_monitoring(false)
	$RunningDust.emitting = false
	$AnimatedSprite.set_speed_scale(1)
	#if player_dead == true:
	#	get_parent().play_lose()
	#$EnemyDamageArea.set_collision_mask(0) # set player spear to cannot kill enemy
	# GAME OVER, player has died. Return to menu
	#if game_status == 1:
	#	get_node("/root/GameStateManager").getScene("res://Scenes/TitleScreen/TitleScreen.tscn")

func screenFlash():
	screen_flash.visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	screen_flash.visible = false
	

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

# Spear cooldown finished, able to throw spear again
func _on_SpearCooldownTimer_timeout():
	get_node("SpearCooldownTimer").wait_time = spearCooldown
	spearThrowable = true
	set_thrown(false)


func _on_DeathTimer_timeout():
	get_parent().play_lose()
