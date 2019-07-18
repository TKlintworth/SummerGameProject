extends KinematicBody2D

onready var Player = get_parent().get_node("Player")

var react_time = 0
var dir = 0
var next_dir = 0
var next_dir_time = 0
var vel = Vector2(0,0)
var attack = false
var hit = false
var area_entered = false
var enemy_attack_noise
var animation_done
var scene_done = false

func _ready():
	set_process(true)
	animation_done = true


func _process(delta):
	if attack == false:
		$AnimatedSprite.play("redguard_idle")
	#elif animation_done == true:
	else:
		#animation_done = false
		
		#$AudioStreamPlayer2D.play_attack_noise()
		if animation_done == true && Player.player_dead == false:
			animation_done = false
			$AnimatedSprite.play("redguard_attack")
			#$AudioStreamPlayer.play_attack_noise()
		#elif animation_done == true && Player.player_dead == true && scene_done == false:
		#	$AudioStreamPlayer2D.play_noise()
		#	scene_done == true
		#if player is in the sense area of the enemy when enemy animation reaches frame 3, player takes damage
		if $AnimatedSprite.get_frame() == 3 and area_entered == true:
			Player.take_damage()
	if hit == true:
		get_parent().destroy_spear()
		get_parent().destroy_enemy()
	var difference = Player.position.y - self.position.y
	if(difference < 1 and difference > -1):
		vel.y = 0
	elif(Player.position.y < self.position.y and next_dir != -1):
		vel.y = -200
	elif(Player.position.y > self.position.y and next_dir != 1):
		vel.y = 200
	vel = move_and_slide(vel)

func _on_SenseArea_area_entered(area):
	print("area enter")
	area_entered = true
	


func _on_SenseArea_area_exited(area):
	print("area exit")
	area_entered = false

func _on_AnimatedSprite_animation_finished():
	animation_done = true
