extends KinematicBody2D

export (int) var speed

#var man_spear = preload("res://manSpear.png")
var velocity = Vector2()

func get_input():
	velocity = Vector2()
	var sprint = false
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
		$AnimatedSprite.set_flip_h(true)
		$AnimatedSprite.play("run_spear")
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		$AnimatedSprite.set_flip_h(false)
		$AnimatedSprite.play("run_spear")
	if Input.is_action_pressed("down"):
		velocity.y += 1
		$AnimatedSprite.play("run_spear")
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		$AnimatedSprite.play("run_spear")
	if Input.is_action_pressed("shift"):
		$AnimatedSprite.set_speed_scale(1.5)
		$AnimatedSprite.play("run_spear")
		sprint = true
	else:
		sprint = false
		$AnimatedSprite.set_speed_scale(1)
	if Input.is_action_pressed("left") == false && Input.is_action_pressed("down") == false && Input.is_action_pressed("right") == false && Input.is_action_pressed("up") == false:
		#$AnimatedSprite.stop()
		$AnimatedSprite.play("idle_spear")
	if sprint == false:
		velocity = velocity.normalized() * speed
	else:
		velocity = velocity.normalized() * (speed+500)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)