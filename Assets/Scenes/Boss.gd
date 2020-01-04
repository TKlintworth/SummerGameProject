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

var vel = Vector2()
var states = ["idle", "lightSwipe", "heavySwipe", "charge", "triShout"]
var stack = []
var activeState = funcref(self, "idle")

#func setState(state):
#	if state in states:
#		activeState = funcref(self, state)
#	else:
#		print("Trying to set an invalid state")

func popState():
	return stack.pop_back()
	
func pushState(state):
	if(getCurrentState() != state):
		stack.push_back(state)
		if state in states:
			activeState = funcref(self, state)

func getCurrentState():
	if len(stack) > 0:
		return stack[len(stack)-1]

func idle():
	print("Idle state")
	pushState("heavySwipe")

func lightSwipe():
	print("light swipe state")

func heavySwipe():
	print("heavy swipe state")

func charge():
	print("charge state")
	
func triShout():
	print("triShout state")

func _physics_process(delta):
	if activeState != null:
		activeState.call_func()



