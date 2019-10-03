extends KinematicBody2D

signal attack_finished
signal animation_finished
signal enemyInMovementZone

onready var Player = get_parent().get_node("Player")
onready var enemyMovementZones = get_parent().get_node("enemyMovementZones")

const SPEED = 320.0
var health = 100.0
var playerAlive
var react_time = 0
var dir = 1
var attacking = false
var enemyMovementZoneChosen = false
var isEnemyInMovementZone = false
#Used around line 80 to choose a zone to run to only once
var runToZone
var last_position
var t = 0
var player_distance
var vel = Vector2()
var state = "idle"
var states = ["idle", "inCombat", "fleeing"]

func _ready():
	playerAlive = !Player.player_dead
	set_process(true)
	
func change_state(var nextState):
	if nextState == "inCombat":
		state = "inCombat"
	if nextState == "fleeing":
		state = "fleeing" #was states[2]?
	if nextState == "idle":
		state = "idle"

#func _on_Area2D_area_entered(area: Area2D) -> void:
#	pass
	#print(area.name)
	#if area.name == "attackZone":
	#	attacking = true
	#if area.name == "attackZone":
	#	attacking = true
		
# Seperating out playing attack animations into chooseable attacks
func choose_attack(attack):
	if attack == "light_flurry":
		#print("ATTACKING")
		# Light flurry plays individual attack animations faster
		$AnimatedSprite.speed_scale = 1.85
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		$AnimatedSprite.play("redguard_attack")
		yield(get_node("AnimatedSprite"), "animation_finished")
		emit_signal("attack_finished")
		#$AnimatedSprite.speed_scale = 1
	# Add more attack types ...

func ai_get_direction(target):
	return (target.position - self.position).normalized()

func _physics_process(delta):
	#var dis_to_player = Player.global_position - self.global_position
	#var distance = dis_to_player.length()
	#var direction = dis_to_player.normalize()
	#print(state)
	#print(attacking)
	if state == "inCombat":
		#if Player.position.x > position.x:
		#	vel.x += SPEED
		if attacking == false:
			dir = Player.position
			position = position.linear_interpolate(Player.position, 0.001)
			#print("position fleeing,", position)
			#print(dir)
			#dir = (Player.position - position).normalized()
			#print("dir,",dir)
			#var motion = dir * SPEED * delta
			#print("motion,",motion)
			$AnimatedSprite.play("heavy_enemy_running")
			#print("MOTION IN COMBAT", motion)
			#position += motion
		if attacking == true:
			#"light flurry" attack
			#choose_attack("light_flurry")
			#yield(self, "attack_finished")
			# Change state to flee after attack
			attacking = false
			change_state("fleeing")
			
		#print(position.normalized(), Player.position.normalized())
		#print("in combat")
		
	if(state == "fleeing"):
		#dir = (Player.global_position - self.global_position).normalized()
			#print("dir,",dir)
		#lerp??
		#var motion = (dir * SPEED * delta)
		#print("motion,",motion)
		
		#position += position.linear_interpolate(Vector2(1,0), 0.5)
		#move_and_slide(Vector2(-100, 0))
		
		#print("fleeing")
		#Choose corner to run to
		#print(enemyMovementZones.zones)
		#if enemyMovementZoneChosen == false:
			#runToZone = chooseMovementZone()
			#print("run to Zone: ", runToZone)
			#last_position = self.position
		#	enemyMovementZoneChosen = true
		#if enemyMovementZoneChosen == true:
			
			position = position.linear_interpolate(Vector2(1500, 450), 0.001)
			$AnimatedSprite.play("heavy_enemy_running")
			#self.position = last_position.linear_interpolate(Vector2(1500, 0), t)
			#print("last position: ", last_position)
			#print("lerp: ")
			#print(last_position.linear_interpolate(Vector2(1500, 0), t))
			#dir = ai_get_direction(runToZone)
			#print(dir)
			#var motion = dir * SPEED * delta
			#print("motion")
			#print(motion)
			#$AnimatedSprite.play("redguard_running")
			#position += motion
			#move_and_slide(motion) 
			
			#if isEnemyInMovementZone:
				#print(isEnemyInMovementZone)
			#	attacking = false
			#	change_state("inCombat")
			#	enemyMovementZoneChosen = false
			#enemyMovementZoneChosen = false
		
		
	if state == "idle":
		#print("idle")
		#$AnimatedSprite.play("redguard_idle")
		#print("is player alive?")
		#print(!playerAlive)
		#print(abs(Player.position.x - position.x))
		player_distance = abs(Player.position.x - position.x)
		if(playerAlive && player_distance < 400):
			change_state("inCombat")
		else:
			pass
			#$AnimatedSprite.play("redguard_idle")
	

#func _physics_process(delta):
	#vel = move_and_slide(vel * delta)

func chooseMovementZone():
	var runToIndex = range(0,4)[randi()%range(0,4).size()]
	var runToZone = enemyMovementZones.zones[runToIndex]
	#print("run to zone returned: ", runToZone)
	return runToZone



func _on_attackZone_area_entered(area: Area2D) -> void:
	#print(area.name)
	#if area.name == "attackZone":
	#	attacking = true
	if area.name == "SenseArea":
		attacking = true

func _on_enemyMovementZones_area_entered(area: Area2D) -> void:
	print(area.name)
	print("in a movement zone")
	isEnemyInMovementZone = true
	#return isEnemyInMovementZone


func _on_enemyMovementZones_area_exited(area: Area2D) -> void:
	isEnemyInMovementZone = false


func _on_SenseArea_area_entered(area: Area2D):
	print(area.name)
	if area.name == "attackZone":
		attacking = true



