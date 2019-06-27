extends KinematicBody2D

var velocity = Vector2()
export (int) var speed = 360

#var spear_point_pos
export var spear_attack_bool = false
var spear_ready
var player_dead = false
var player_block = false # boolean for if player is blocking
var action = false # boolean for if player is performing an action. E.G. blocking, attacking

onready var player_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/TextureProgress")

#func _ready():
	#pass
#	$AnimatedSprite.play("slave_jab_spear_inactive")
#	spear_point_pos = $Area2D.position.x
#	spear_ready = true
func take_damage():
	player_node.value -= 2
	
#func _on_AnimatedSprite_animation_finished():
#	$AnimatedSprite.play("slave_jab_spear_inactive")
#	spear_attack_bool = false
#	$Area2D.hide()
#	spear_ready = true
#	if(player_dead == true):
#		$AnimatedSprite.hide()

func get_input():
	velocity = Vector2()
	var sprint = false
	
	if (player_node.value <=27):
		player_dead = true
		$AnimatedSprite.play("slave_dying")
	if Input.is_action_pressed("right") && action == false:
		velocity.x += 1
		$AnimatedSprite.set_flip_h(true)
		$AnimatedSprite.play("player_run_spear")
	if Input.is_action_pressed("left") && action == false:
		velocity.x -= 1
		$AnimatedSprite.set_flip_h(false)
		$AnimatedSprite.play("player_run_spear")
	if Input.is_action_pressed("down") && action == false:
		velocity.y += 1
		$AnimatedSprite.play("player_run_spear")
	if Input.is_action_pressed("up") && action == false:
		velocity.y -= 1
		$AnimatedSprite.play("player_run_spear")
	if Input.is_action_pressed("E"):
		player_block = true
		action = true
		$AnimatedSprite.play("slave_block")
	if Input.is_action_pressed("Q"):
		player_dead = true
		$Area2D/AudioStreamPlayer2D.play_noise()
		$AnimatedSprite.play("slave_dying")
	if Input.is_action_pressed("shift"):
		$AnimatedSprite.set_speed_scale(1.5)
		$AnimatedSprite.play("player_run_spear")
		sprint = true
	else:
		sprint = false
		$AnimatedSprite.set_speed_scale(1)
	if Input.is_action_pressed("left") == false && Input.is_action_pressed("down") == false && Input.is_action_pressed("right") == false && Input.is_action_pressed("up") == false && player_dead == false && player_block == false && action == false:
		#$AnimatedSprite.stop()
		$AnimatedSprite.play("player_idle_spear")	
		#$AnimatedSprite.hide()
	if sprint == false:
		velocity = velocity.normalized() * speed
#	if(Input.is_key_pressed(KEY_Y)):
#		take_damage()
	else:
		#sprinting increases speed by 150%
		velocity = velocity.normalized() * (speed+ (0.5*(speed)))

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
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



func _on_AnimatedSprite_animation_finished():
	player_block = false
	if !Input.is_action_pressed("E"):
		action = false
