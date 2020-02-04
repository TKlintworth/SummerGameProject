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

var maxHealth = 500
var dir = 1
var vel = Vector2()
var states = ["recovery", "lightSwipe", "heavySwipe", "charge", "triShout"]
var stack = []
var activeState = funcref(self, "recovery")

# Starting state
func _ready():
	pushState("recovery")

# BEGIN FSM
# NOTE: Each state is responsible for popping itself from the stack

# Function of FSM
# pop state off the top of the state stack
func popState():
	return stack.pop_back()

# Function of FSM
# push state onto top of state stack
func pushState(state):
	if(getCurrentState() != state):
		if state in states:
			activeState = funcref(self, state)
			stack.push_back(activeState)
			#Temporary fix. Call the function as soon as its pushed. This is as opposed to calling every frame like suggested
			stack[len(stack)-1].call_func()

# Function of FSM
# return the state at the top of the state stack
func getCurrentState():
	if len(stack) > 0:
		return stack[len(stack)-1]

# Function of FSM
# Recovery state, details above
func recovery():
	# Dash out of player range
	dash()
	print("recovery state")

# Function of FSM
# light swipe attack function, details above
func lightSwipe():
	print("light swipe state")

# Function of FSM
# heavy swipe attack function, details above
func heavySwipe():
	print("heavy swipe state")
	popState()

# Function of FSM
# quick charge attack function, details above
func charge():
	print("charge state")

# Function of FSM
# triumphant shout attack function, details above
func triShout():
	print("triShout state")

#END FSM functions

# updates every physics frame
func _physics_process(delta):
	
	pass
	# The current state as a funcRef (callable function stored as variable)
	#var currentStateFunction = getCurrentState()
	
	# If there is a current state
	#if currentStateFunction != null:
	#	# Call state function
	#	currentStateFunction.call_func()


func ai_get_direction(target):
	#print("got movement direction")
	return (target.position - self.position).normalized()

func dash():
	print("dash move")
	#dir = ai_get_direction()
	#var motion = (dir * SPEED * delta)
	#if (motion.x > 0):
	#	$AnimatedSprite.set_flip_h(true)
	#else:
	#	$AnimatedSprite.set_flip_h(false)
	
	#position += motion



