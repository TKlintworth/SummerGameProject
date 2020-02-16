extends KinematicBody2D

signal attack_finished
#signal animation_finished
signal enemyInMovementZone
#signal enemy hit by spear
signal enemy_hit

onready var Player = get_parent().get_node("Player")
onready var enemyMovementZones = get_parent().get_node("enemyMovementZones")
onready var knockbackEffect = get_node("knockbackEffect")
onready var enemy = self

var SPEED = 320.0
var health = 100.0
var playerAlive
var react_time = 0
var stunned = false
var dir = 1
var noise_played = false
var attacking = false
var dead = false
var enemyMovementZoneChosen = false
var isEnemyInMovementZone = false
var player_recently_taken_damage = false
var enemy_recently_attacked = false
#How long before player can take damage again after receiving damage (in seconds)
var playerDamageTime = 3
var enemyStunTime = 3
var enemyAttackDelay = 1
var stunTimerStart = false
#Used around line 80 to choose a zone to run to only once
var runToZone
var last_position
var t = 0
var rng = RandomNumberGenerator.new()
var in_attack_zone = false
var player_distance
var vel = Vector2()
var idle_timer = false
var idle_timer_start = false
var state = "idle"
var states = ["idle", "inCombat", "fleeing", "stunned", "stopped", "dying", "finished"]
var knockbackDistance = 50
var played_death_animation = false

#Amount of damage the one_time_attack inflicts
var oneTimeAttackDamage = 20

func _ready():
	playerAlive = !Player.player_dead
	rng.randomize()
	var random_speed = rng.randi_range(250, 350)
	set_speed(random_speed)
	set_process(true)
	
func get_health():
	return health	

func lose_health_spear_jab():
	emit_signal("enemy_hit")
	health -= 50
	knockback()
	return health

func play_blood_one_time():
	$BloodParticles.emitting = true

func play_blood_flow():
	$BloodParticles.one_shot = false
	$BloodParticles.emitting = true

func play_blood_splash_one_time():
	$BloodSplashParticles.emitting = true	

func play_death():
	dead = true
	change_state("dying")

func set_speed(speed):
	SPEED = speed

func disable_collision():
	$CollisionShape2D.disabled = true
	
func enable_collision():
	$CollisionShape2D.disabled = false

func change_state(var nextState):
	if nextState == "inCombat":
		state = "inCombat"
	if nextState == "fleeing":
		state = "fleeing" #was states[2]?
	if nextState == "idle":
		state = "idle"
	if nextState == "stunned":
		state = "stunned"
	if nextState == "stopped":
		state = "stopped"
	if nextState == "dying":
		state = "dying"
	if nextState == "finished":
		state = "finished"

		
# Seperating out playing attack animations into chooseable attacks
func choose_attack(attack):
	
	if attack == "light_flurry":
		# Light flurry plays individual attack animations faster
		$AnimatedSprite.speed_scale = 1.85
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		#emit_signal("attack_finished")
		attacking = false
		change_state("fleeing")
		
	elif attack == "one_time_attack":
		$AnimatedSprite.speed_scale = 1.85
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		
		#IF player isn't blocking and they're in the attack zone at the end of the attack animation, recieve damage
		if(Player.player_block == false and in_attack_zone == true and not player_recently_taken_damage):
			Player.take_damage(45)
			player_recently_taken_damage = true
			player_damage_timer()
		elif(Player.player_block == true and in_attack_zone == true and not player_recently_taken_damage):
				stunned = true
				#Decrease player stamina by half the value of the potential damage inflicted
				Player.lose_stamina(oneTimeAttackDamage/2)
				change_state("stunned")		
		attacking = false
		change_state("fleeing")
		#$AnimatedSprite.speed_scale = 1
	# Add more attack types ...

func ai_get_direction(target):
	#print("got movement direction")
	return (target.position - self.position).normalized()

#Timer for allowing player to take more damage after being damaged
func player_damage_timer():
	if(Player.player_health_node.value > 0): #dont blink if player is dead on the ground
		get_tree().get_root().get_node("MainRoot/Player/AnimationPlayer").play("blink")
		yield(get_tree().create_timer(playerDamageTime), "timeout")
		player_recently_taken_damage = false

func enemy_stun_timer():
	knockback()
	yield(get_tree().create_timer(enemyStunTime), "timeout")
	stunned = false
	stunTimerStart = false
	change_state("idle")



func enemy_delay_timer():
	yield(get_tree().create_timer(enemyAttackDelay), "timeout")
	enemy_recently_attacked = false

func _physics_process(delta):
	if(Player.game_status==1):
		change_state("finished")
	#var dis_to_player = Player.global_position - self.global_position
	#var distance = dis_to_player.length()
	#var direction = dis_to_player.normalize()
	elif state == "inCombat" && dead == false:
		
		if attacking == false:
			var distance_to_player = self.global_position.distance_to(Player.global_position)
			if (distance_to_player > 350):
				change_state("idle")
			
			dir = (Player.position - position).normalized()
			var motion = dir * SPEED * delta
			if (motion.x > 0):
				$AnimatedSprite.set_flip_h(true)
			else:
				$AnimatedSprite.set_flip_h(false)
			$AnimatedSprite.play("redguard_running")
			position += motion
			
		if attacking == true:
			#"light flurry" attack
			choose_attack("one_time_attack")
			#attacking = false
			yield(self, "attack_finished")
			# Change state to flee after attack
			attacking = false
			#change_state("fleeing")
		
	elif(state == "fleeing" && dead == false):
		
		
		if(stunned == true):
			change_state("stunned")
		
		# If enemy is in player's attack zone, keep attacking
		elif(in_attack_zone == true && health > 61):
			attacking = true
			change_state("inCombat")
			
		elif(in_attack_zone == false && health > 61):		
			rng.randomize()
			var random_decision = rng.randi_range(0, 1)
			match random_decision:
				0:
					change_state("inCombat")
				1:
					change_state("idle")
						
		elif(in_attack_zone == true && health <= 60):
			if enemyMovementZoneChosen == false:
				rng.randomize()
				var random_decision = rng.randi_range(0, 2)
				match random_decision:
					0:  # Run to movement zone
						runToZone = chooseMovementZone()
						in_attack_zone = false
						enemyMovementZoneChosen = true
					#1: # Run towards player
					#	attacking = true
					#	change_state("inCombat") 
					1,2:
						attacking = true
						change_state("inCombat")
						
				if enemyMovementZoneChosen == true:	
					disable_collision()
					dir = ai_get_direction(runToZone)
					var motion = (dir * SPEED * delta)
					if (motion.x > 0):
						$AnimatedSprite.set_flip_h(true)
					else:
						$AnimatedSprite.set_flip_h(false)
					$AnimatedSprite.play("redguard_running")
					
					position += motion
					
					if isEnemyInMovementZone:
						enable_collision()
						enemyMovementZoneChosen = false
						change_state("idle")
				
		# If enemy is outside player's attack zone, choose to keep attacking or flee
		elif(in_attack_zone == false && health <= 51):
		#Choose corner to run to
			if enemyMovementZoneChosen == false:
				rng.randomize()
				var random_decision = rng.randi_range(0, 4)
				match random_decision:
					0,1:  # Run to movement zone
						#if(health <= 51):
						runToZone = chooseMovementZone()
						enemyMovementZoneChosen = true
						#else:
						#	change_state("idle")
					2,3,4: # Run towards player
						attacking = false
						change_state("inCombat") 
			
			if enemyMovementZoneChosen == true:	
				disable_collision()
				dir = ai_get_direction(runToZone)
				var motion = (dir * SPEED * delta)
				if (motion.x > 0):
					$AnimatedSprite.set_flip_h(true)
				else:
					$AnimatedSprite.set_flip_h(false)
				$AnimatedSprite.play("redguard_running")
				position += motion
			
			
				if isEnemyInMovementZone:
			#	attacking = false
					enable_collision()
					enemyMovementZoneChosen = false
					#if(self.health <= 33):
					change_state("idle")
					#else:
					#	change_state("inCombat")
				
			#enemyMovementZoneChosen = false
		
		
	elif state == "idle" && dead == false:		
			$AnimatedSprite.speed_scale = 1
			var distance_to_player = self.global_position.distance_to(Player.global_position)
			#player_distance = abs(Player.position.x - position.x)
			if(playerAlive && distance_to_player < 300):
				change_state("inCombat")
			else:
				if Player.position.x - self.position.x < 0:
					$AnimatedSprite.set_flip_h(false)
					$AnimatedSprite.play("redguard_idle")
				else:
					$AnimatedSprite.set_flip_h(true)
					$AnimatedSprite.play("redguard_idle")
	
	if state == "stunned" && dead == false:
		$AnimatedSprite.play("redguard_stun")
		if !stunTimerStart:
			stunTimerStart = true
			enemy_stun_timer()
			
	
	
	
	elif state == "stopped" && dead == false:
		player_distance = abs(Player.position.x - position.x)
		if(player_distance < 50):
			change_state("inCombat")
		$AnimatedSprite.play("redguard_idle")
		if(idle_timer_start == false):
			$IdleWaitTimer.start()
			idle_timer_start = true
			
	
	elif state == "dying":
		dead = true
		var x_pos = self.position.x
		var y_pos = self.position.y
		if !noise_played:
			noise_played = true
			get_tree().get_root().get_node("MainRoot/AudioStreamPlayer2D").play_enemy_death_noise()
		disable_collision()
		$AnimatedSprite.play("redguard_dying")
		$BloodParticles.emitting = false
		yield(get_node("AnimatedSprite"), "animation_finished")
		if !played_death_animation:
			played_death_animation = true
			rng.randomize()
			var random_decision = rng.randi_range(0, 1)
			match random_decision:
				0:
					get_tree().get_root().get_node("MainRoot").add_health_enemy_drop(x_pos, y_pos)
				1:
					pass	
			self.queue_free()
	
	elif(state=="finished"):
		$AnimatedSprite.play("redguard_idle")
		attacking=false
	
func chooseMovementZone():
	if(Player.position.x - self.position.x > 0):
		var runToIndex = range(0,2)[randi()%range(0,2).size()]
		var runToZone = enemyMovementZones.zones[runToIndex]
		return runToZone
	else:
		var runToIndex = range(2,4)[randi()%range(2,4).size()]
		var runToZone = enemyMovementZones.zones[runToIndex]
		return runToZone
	
	

func _on_enemyMovementZones_area_entered(area: Area2D) -> void:
	

	#if self.health <= 33:
	isEnemyInMovementZone = true
	#return isEnemyInMovementZone


func _on_enemyMovementZones_area_exited(area: Area2D) -> void:

	isEnemyInMovementZone = false


func _on_SenseArea_area_entered(area: Area2D):

	if area.name == "attackZone" && state == "inCombat":
		attacking = true
		in_attack_zone = true
		isEnemyInMovementZone = false
	if area.is_in_group("EnemyMovementZone"):

		isEnemyInMovementZone = true
		attacking = false

func _on_SenseArea_area_exited(area):
	if area.name == "attackZone":
		in_attack_zone = false
		#print("left attack zone")


func _on_IdleWaitTimer_timeout():
	$IdleWaitTimer.wait_time = 5
	change_state("inCombat")

# Function to move the enemy backwards slightly after receiving a hit from the player
# TO ADD: no knockback if that specific hit will kill the enemy, no knockback if the enemy is stunned maybe
func knockback():
	flashRed()
	
	dir = (Player.position - position).normalized()
	print("enemy direction")
	print(dir)
	var newPos = position + (knockbackDistance * -dir)
	
	knockbackEffect.interpolate_property(self, "position", null, newPos, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	knockbackEffect.start()
	
	#print("direction " , dir)
	#var knockbackDistance = 50
	#position += knockbackDistance * -dir
	#move_and_collide(knockbackDistance * -dir)
	print("enemy knock back position", position)

#Quickly modulate the enemy red to show damage
func flashRed():
	self.modulate = Color(1,0,0,1)
	yield(get_tree().create_timer(0.1), "timeout")
	self.modulate = Color(1,1,1,1)
