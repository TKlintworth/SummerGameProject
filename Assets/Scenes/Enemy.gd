extends KinematicBody2D

signal attack_finished

onready var Player = get_parent().get_node("Player")

const SPEED = 320.0
var health = 100.0
var playerAlive
var react_time = 0
var dir = 1
var attacking = false
#var next_dir = 0
#var next_dir_time = 0
var vel = Vector2()
#var attack = false
var state = "inCombat"
var states = ["idle", "inCombat", "fleeing"]

func _ready():
	playerAlive = !Player.player_dead
	set_process(true)

func change_state(nextState):
	if nextState == "inCombat":
		state = "inCombat"
	if nextState == "fleeing":
		state = states[2]
	else:
		state = "idle"

func _on_Area2D_area_entered(area: Area2D) -> void:
	#print(area.name)
	if area.name == "attackZone":
		attacking = true
		
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
		emit_signal("attack_finished")
	# Add more attack types ...

func _process(delta):
	print(state)
	#print(attacking)
	if state == "inCombat":
		#if Player.position.x > position.x:
		#	vel.x += SPEED
		if attacking == false:
			print("position fleeing,", position)
			dir = (Player.position - position).normalized()
			print("dir,",dir)
			var motion = dir * SPEED * delta
			print("motion,",motion)
			$AnimatedSprite.play("redguard_running")
			position += motion
		if attacking == true:
			#"light flurry" attack
			choose_attack("light_flurry")
			yield(self, "attack_finished")
			# Change state to flee after attack
			change_state(states[2])
			attacking = false
		#print(position.normalized(), Player.position.normalized())
		#print("in combat")
		
	if(state == "fleeing"):
		#print("fleeing")
		print("position fleeing,", position)
		dir = -1.0*(Player.position - position).normalized()
		var motion = dir * SPEED * delta
		$AnimatedSprite.play("redguard_running")
		position += motion
		
	if state == "idle":
		print("idle")
		$AnimatedSprite.play("redguard_idle")
		#print("is player alive?")
		#print(!playerAlive)
		if(playerAlive):
			change_state("inCombat")
		else:
			$AnimatedSprite.play("redguard_idle")
	

func _physics_process(delta):
	vel = move_and_slide(vel * delta)


