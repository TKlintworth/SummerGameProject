extends KinematicBody2D

signal attack_finished
#signal animation_finished
signal enemyInMovementZone

onready var Player = get_parent().get_node("Player")
onready var enemyMovementZones = get_parent().get_node("enemyMovementZones")

var SPEED = 320.0
var health = 100.0
var playerAlive
var react_time = 0
var dir = 1
var attacking = false
var dead = false
var enemyMovementZoneChosen = false
var isEnemyInMovementZone = false
var player_recently_taken_damage = false
#How long before player can take damage again after receiving damage (in seconds)
var playerDamageTime = 5
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
var states = ["idle", "inCombat", "fleeing", "stopped", "dying"]

func _ready():
	playerAlive = !Player.player_dead
	rng.randomize()
	var random_speed = rng.randi_range(250, 350)
	set_speed(random_speed)
	set_process(true)
	
func get_health():
	return health	

func lose_health_spear_jab():
	health -= 50
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

func change_state(var nextState):
	if nextState == "inCombat":
		state = "inCombat"
	if nextState == "fleeing":
		state = "fleeing" #was states[2]?
	if nextState == "idle":
		state = "idle"
	if nextState == "stopped":
		state = "stopped"
	if nextState == "dying":
		state = "dying"

		
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
			print("player take damage")
			#Player.take_damage(45)
			player_recently_taken_damage = true
			player_damage_timer()
		attacking = false
		change_state("fleeing")
		#$AnimatedSprite.speed_scale = 1
	# Add more attack types ...

func ai_get_direction(target):
	#print("got movement direction")
	return (target.position - self.position).normalized()

#Timer for allowing player to take more damage after being damaged
func player_damage_timer():
	yield(get_tree().create_timer(playerDamageTime), "timeout")
	player_recently_taken_damage = false

func _physics_process(delta):
	
	#var dis_to_player = Player.global_position - self.global_position
	#var distance = dis_to_player.length()
	#var direction = dis_to_player.normalize()
	if state == "inCombat" && dead == false:
		if attacking == false:
			var player_distance_x = abs(Player.position.x - position.x)
			var player_distance_y = abs(Player.position.y - position.y)
			
			if (player_distance_x > 350 or player_distance_y > 350):
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
		
	if(state == "fleeing" && dead == false):
		
		# If enemy is in player's attack zone, keep attacking
		if(in_attack_zone == true && health > 61):
			attacking = true
			change_state("inCombat")
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
					dir = ai_get_direction(runToZone)
					var motion = (dir * SPEED * delta)
					if (motion.x > 0):
						$AnimatedSprite.set_flip_h(true)
					else:
						$AnimatedSprite.set_flip_h(false)
					$AnimatedSprite.play("redguard_running")
					
					position += motion
					
					if isEnemyInMovementZone:
						
						enemyMovementZoneChosen = false
						change_state("idle")
				
		# If enemy is outside player's attack zone, choose to keep attacking or flee
		elif(in_attack_zone == false):
		#Choose corner to run to
			if enemyMovementZoneChosen == false:
				rng.randomize()
				var random_decision = rng.randi_range(0, 4)
				match random_decision:
					0,1:  # Run to movement zone
						if(health <= 51):
							runToZone = chooseMovementZone()
							enemyMovementZoneChosen = true
						else:
							change_state("idle")
					2,3,4: # Run towards player
						attacking = false
						change_state("inCombat") 
			
			if enemyMovementZoneChosen == true:	
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
					enemyMovementZoneChosen = false
					if(self.health <= 33):
						change_state("idle")
					else:
						change_state("inCombat")
				
			#enemyMovementZoneChosen = false
		
		
	if state == "idle" && dead == false:		
			player_distance = abs(Player.position.x - position.x)
			if(playerAlive && player_distance < 200):
				change_state("inCombat")
			else:
				if Player.position.x - self.position.x < 0:
					$AnimatedSprite.set_flip_h(false)
					$AnimatedSprite.play("redguard_idle")
				else:
					$AnimatedSprite.set_flip_h(true)
					$AnimatedSprite.play("redguard_idle")		
	
	if state == "stopped" && dead == false:
		player_distance = abs(Player.position.x - position.x)
		if(player_distance < 50):
			change_state("inCombat")
		$AnimatedSprite.play("redguard_idle")
		if(idle_timer_start == false):
			$IdleWaitTimer.start()
			idle_timer_start = true
			
	
	if state == "dying":
		disable_collision()
		$AnimatedSprite.play("redguard_dying")
		if($AnimatedSprite.frame >= 9):
			self.queue_free()
	
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
	
	print("in a movement zone")
	#if self.health <= 33:
	isEnemyInMovementZone = true
	#return isEnemyInMovementZone


func _on_enemyMovementZones_area_exited(area: Area2D) -> void:
	print("left movement zone")
	isEnemyInMovementZone = false


func _on_SenseArea_area_entered(area: Area2D):
	print(area.name)
	if area.name == "attackZone" && state == "inCombat":
		attacking = true
		in_attack_zone = true
		isEnemyInMovementZone = false
	if area.is_in_group("EnemyMovementZone"):
		print("zone entered")
		isEnemyInMovementZone = true
		attacking = false

func _on_SenseArea_area_exited(area):
	if area.name == "attackZone":
		in_attack_zone = false
		print("left attack zone")





func _on_IdleWaitTimer_timeout():
	print("timer done")
	$IdleWaitTimer.wait_time = 5
	change_state("inCombat")
