extends KinematicBody2D

var vel = Vector2()

var left = false
var right = false
var up = false
var down = false

var spear_point_pos
export var spear_attack_bool = false
var spear_ready

onready var player_node = get_parent().get_node("CanvasLayer/Control/NinePatchRect/TextureProgress")

func _ready():
	$AnimatedSprite.play("slave_jab_spear_inactive")
	spear_point_pos = $Area2D.position.x
	spear_ready = true
	


func _physics_process(delta):
	if(Input.is_key_pressed(KEY_LEFT) && spear_ready == true):
		$AnimatedSprite.set_flip_h(false)
		$Area2D.position.x = spear_point_pos
		vel.x = -300
		left = true
		right = false
		down = false
		up = false
	elif(Input.is_key_pressed(KEY_RIGHT) && spear_ready == true):
		$AnimatedSprite.set_flip_h(true)
		$Area2D.position.x = spear_point_pos * (-1)
		vel.x = 300
		left = false
		right = true
		down = false
		up = false
	elif(Input.is_key_pressed(KEY_DOWN)):
		vel.y = 300
		left = false
		right = false
		down = true
		up = false
	elif(Input.is_key_pressed(KEY_UP)):
		vel.y = -300
		left = false
		right = false
		down = false
		up = true
	else:
		vel.x = 0
		vel.y = 0
	
	vel = move_and_slide(vel)
	
	if(Input.is_key_pressed(KEY_T)):
		spear_ready = false
		$Area2D.show()
		$AnimatedSprite.play("slave_jab_spear_active")
		if $AnimatedSprite.flip_h == false:
			$Area2D/AnimationPlayer.play("spear_attack")
		if $AnimatedSprite.flip_h == true:
			$Area2D/AnimationPlayer.play("spear_attack_right")
		spear_attack_bool = true
		
	
	if(Input.is_key_pressed(KEY_Y)):
		take_damage()
	
#
#func _input(event):
#	if(event.is_action_pressed("shoot")):
#		$AnimatedSprite.play("idle")
func take_damage():
	player_node.value -= 2

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("slave_jab_spear_inactive")
	spear_attack_bool = false
	$Area2D.hide()
	spear_ready = true
