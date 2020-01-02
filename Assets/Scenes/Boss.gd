extends KinematicBody2D
# A tooltip pauses the game and offers general gameplay controls (movement, attack, block)

# Boss : Rius
# Stages: Beginning, Middle, End
# Skills to Test (Teach): Movement, blocking, attack
# Rius Attacks: 
# Beginning Stage (Health > 50%)
# Light Swipe (quick attack, low damage)
# Heavy Swipe (slow attack, unblockable, high damage)
# Charge (unable to hit while charging)
# Middle Stage (50% > Health > 25% )
# Triumphant Shout 
# He puts away his weapon, looks up and screams, causing an AoE stun within a circle radius that also deals damage, immediately engages once stunned
#	End Stage (Health < 25%)
#		Desperate Frenzy
#			Speed is increased by 25% for all attacks
#			No longer dashes to avoid attacks
#			Uses Charge more frequently	

# Rius Traits:
# Able to attack while being attacked
# Dash Ability to avoid damage
# Large Health Pool

# Functions:
# 	playerPosCheck:
#		description: Return the current position of the player
#		parameters: None
#		return: Position of the player
# 	setState:
#		description: Create a funcref object to  (call the function) reference the state function
#		parameters: a string variable containing one of the states
#		return: None


var states = ["idle", "light_swipe", "heavy_swipe", "charge", "tri_shout"]
var activeState = funcref(self, "idle")

func setState(state):
	if state in states:
		activeState = funcref(self, state)
	else:
		print("Trying to set an invalid state")

func idle():
	print("Idle state")

func _physics_process(delta):
	if activeState != null:
		activeState.call_func()



