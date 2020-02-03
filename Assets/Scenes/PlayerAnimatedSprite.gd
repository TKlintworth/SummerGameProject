extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func blink_on():
	self_modulate.a = 1

func blink_off():
	self_modulate.a = 0.5
