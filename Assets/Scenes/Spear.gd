extends KinematicBody2D

var vel = Vector2()
export (int) var speed_x = 400
export (int) var speed_y = 0
var sec = 0.0
var timer_done = false
var timer_start = false
var direction
var waited = 0
var waited_spear = 0
var delay = 1
var spear_distance = 2
var rotate = true
var thrown = false


func _ready():
	self.hide() # spear is added to scene but don't want it to be visible quite yet (until animation is finished)
	thrown = false
	
	# do this so that when spear object is made, it does not hit anything until visible
	self.set_collision_mask(0)
	self.set_collision_layer(0)

func get_input():
	if Input.is_action_pressed("T") && thrown == false:
		thrown = true
		timer_start = true
		
		match direction:
			0:  # player facing left, so throw spear left
				$AnimatedSprite.play("spear_flight")
				vel.x = -speed_x
				vel.y = speed_y
			1: # player facing right, so throw spear right
				$AnimatedSprite.set_flip_h(true)
				$AnimatedSprite.play("spear_flight")
				vel.x = speed_x
				vel.y = speed_y
		

func _process(delta):
	direction = get_parent().get_node("Player").character_direction
	
	if (timer_start == true): #timer starts when "throw" button is pressed
		if (waited >= delay): #throw spear after 1 second
			self.show()
			self.set_collision_mask(1) #spear can now hit enemy
			self.set_collision_layer(1)
			timer_done = true
		else:
			waited += delta
			
		if (waited_spear >= spear_distance): #stop spear after 2 seconds
			rotate = false
			vel.x = 0
			vel.y = 0
			self.position = Vector2(self.position.x, self.position.y + 35) # lower spear when distance is reached to look more natural
			match direction: # rotate spear into ground when max distance is reached
				0: self.rotate(deg2rad(-30))
				1: self.rotate(deg2rad(30))
			
			timer_start = false
		else:
			waited_spear += delta
			
	elif (timer_start == false): # if spear has not been thrown, timer is at 0
		waited = 0
		
	if(timer_done == true && rotate == true): # make spear move
		match direction: # rotate spear at 5 degrees per second
			0: self.rotate(deg2rad(-5*delta))
			1: self.rotate(deg2rad(5*delta)) 
		
		vel = move_and_slide(vel)
		
	get_input()
	

func _on_Area2D_area_entered(area):
	if(area.name == "DamageArea"):
		area.get_parent().queue_free()
		self.queue_free()
